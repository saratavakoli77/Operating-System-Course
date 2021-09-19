// Console input and output.
// Input is from the keyboard or serial port.
// Output is written to the screen and serial port.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"

static void consputc(int);

static int panicked = 0;

#define INPUT_BUF 128
struct {
  char buf[INPUT_BUF];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
  uint end; //end of the buffer
} input;
static struct {
  struct spinlock lock;
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
    consputc(buf[i]);
}
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
      break;
    }
  }

  if(locking)
    release(&cons.lock);
}

void
panic(char *s)
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
  for(;;)
    ;
}

//PAGEBREAK: 50
#define BACKSPACE 0x100
#define CRTPORT 0x3d4
#define CURLY_LEFT '{'
#define CURLY_RIGHT '}'
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
  }
  else if(c == CURLY_LEFT){
    // if(input.end > 78 && input.e >78){
    //     pos -= pos%80 + 80 - 2;
    // }
    // else{
    //   if(pos > 0) {
    //     pos -= pos%80 - 2;
    //   }
    // }
    pos -= (input.e - input.w);
  }
  else if(c == CURLY_RIGHT){
    // if(input.end > 78){
    //     pos -= pos%80 + 80 - 2;
    // }
    // else{
    //   if(pos > 0) {
    //     pos += input.end-input.e;
    //   }
    // }
    pos += input.end-input.e;
  }
  else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  if(c != CURLY_LEFT && input.e == input.end)
    crt[pos] = ' ' | 0x0700;
}

void 
changePos(int change)
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  pos += change;

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
  }

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
}

void
consputc(int c)
{
  if(panicked){
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  }
  else
    uartputc(c);
  cgaputc(c);
}



#define C(x)  ((x)-'@')  // Control-x


void
shiftToRight(char* buffer, int end, int start)
{
  for(int i = end; i >= start; i--){
    buffer[i+1] = buffer[i];
  }
}

void
shiftToLeft(char* buffer, int end, int start)
{
  for(int i = start; i <= end; i++){
    buffer[i-1] = buffer[i];
  }
}

void
killLine()
{
  changePos(input.end-input.e);
    input.e = input.end;
    while(input.end != input.w &&
          input.buf[(input.e-1) % INPUT_BUF] != '\n'){
      input.e--;
      input.end--;
      consputc(BACKSPACE);
    }
}

void
handleWriteInmid(int c)
{
  shiftToRight(input.buf, input.end, input.e);
  input.buf[input.e % INPUT_BUF] = c;
  changePos(input.end-input.e);
  for(int i = input.w; i < input.end; i++){
    consputc(BACKSPACE);
  }
  
  for(int i = input.w; i <= input.end; i++){
    consputc(input.buf[i]);
  }
  changePos(-(input.end-input.e));
  input.end++;
  input.e++;
}

void
handleBackspaceInMid()
{
  shiftToLeft(input.buf, input.end, input.e);
  changePos(input.end-input.e);
  for(int i = input.w; i < input.end; i++){
    consputc(BACKSPACE);
  }
  for(int i = input.w; i < input.end; i++){
    consputc(input.buf[i]);
  }
  changePos(-(input.end-input.e+1));
  input.end--;
  input.e--;
}

void
finalDecision(int c)
{
  if(c == '\n' || c == C('D') || input.end == input.r+INPUT_BUF){
    changePos(input.end-input.e);
    input.e = input.end;
    input.w = input.e;
    wakeup(&input.r);
  } 
}

void
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      killLine();
      break;
    case C('C'):  // Kill line.
      killLine();
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        if(input.e < input.end){
          handleBackspaceInMid();
        }
        else{
          input.e--;
          input.end--;
          consputc(BACKSPACE);
        }
      }
      break;
    default:
      if(c != 0 && input.end-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        if (c == '\n'){
          changePos(input.end-input.e);
          input.e = input.end;

          shiftToRight(input.buf, input.end, input.e);
          input.buf[input.e++ % INPUT_BUF] = c;
          input.end++;
          
          consputc(c);
          finalDecision(c);
        }
        else if(c == CURLY_LEFT){
          cgaputc(c);
          input.e = input.w;
        }
        else if(c == CURLY_RIGHT){
          cgaputc(c);
          input.e = input.end;
        }
        else if(input.e < input.end){
          handleWriteInmid(c);
          finalDecision(c);
        }
        else{
          shiftToRight(input.buf, input.end, input.e);
          input.buf[input.e++ % INPUT_BUF] = c;
          input.end++;
          
          consputc(c);
          finalDecision(c);
        } 
      } 
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
  uint target;
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
    consputc(buf[i] & 0xff);
  release(&cons.lock);
  ilock(ip);

  return n;
}

void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
}

