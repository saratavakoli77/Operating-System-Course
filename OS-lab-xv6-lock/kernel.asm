
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2e 10 80       	mov    $0x80102ea0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
80100044:	bb 18 b6 10 80       	mov    $0x8010b618,%ebx
80100049:	83 ec 0c             	sub    $0xc,%esp
8010004c:	68 c0 71 10 80       	push   $0x801071c0
80100051:	68 e0 b5 10 80       	push   $0x8010b5e0
80100056:	e8 15 44 00 00       	call   80104470 <initlock>
8010005b:	c7 05 ac fd 10 80 58 	movl   $0x8010fd58,0x8010fdac
80100062:	fd 10 80 
80100065:	c7 05 b0 fd 10 80 58 	movl   $0x8010fd58,0x8010fdb0
8010006c:	fd 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 58 fd 10 80       	mov    $0x8010fd58,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	89 53 58             	mov    %edx,0x58(%ebx)
8010008b:	c7 43 54 58 fd 10 80 	movl   $0x8010fd58,0x54(%ebx)
80100092:	68 c7 71 10 80       	push   $0x801071c7
80100097:	50                   	push   %eax
80100098:	e8 a3 42 00 00       	call   80104340 <initsleeplock>
8010009d:	a1 b0 fd 10 80       	mov    0x8010fdb0,%eax
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
801000a7:	89 58 54             	mov    %ebx,0x54(%eax)
801000aa:	8d 83 60 02 00 00    	lea    0x260(%ebx),%eax
801000b0:	89 1d b0 fd 10 80    	mov    %ebx,0x8010fdb0
801000b6:	3d 58 fd 10 80       	cmp    $0x8010fd58,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801000df:	68 e0 b5 10 80       	push   $0x8010b5e0
801000e4:	e8 e7 44 00 00       	call   801045d0 <acquire>
801000e9:	8b 1d b0 fd 10 80    	mov    0x8010fdb0,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 58 fd 10 80    	cmp    $0x8010fd58,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 58             	mov    0x58(%ebx),%ebx
80100103:	81 fb 58 fd 10 80    	cmp    $0x8010fd58,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
80100115:	83 43 50 01          	addl   $0x1,0x50(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100120:	8b 1d ac fd 10 80    	mov    0x8010fdac,%ebx
80100126:	81 fb 58 fd 10 80    	cmp    $0x8010fd58,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100133:	81 fb 58 fd 10 80    	cmp    $0x8010fd58,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
8010013b:	8b 43 50             	mov    0x50(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100153:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 b5 10 80       	push   $0x8010b5e0
80100162:	e8 39 45 00 00       	call   801046a0 <release>
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 42 00 00       	call   80104380 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 1f 00 00       	call   80102120 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 71 10 80       	push   $0x801071ce
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 6d 42 00 00       	call   80104420 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 71 10 80       	push   $0x801071df
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 2c 42 00 00       	call   80104420 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 41 00 00       	call   801043e0 <releasesleep>
80100204:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010020b:	e8 c0 43 00 00       	call   801045d0 <acquire>
80100210:	8b 43 50             	mov    0x50(%ebx),%eax
80100213:	83 c4 10             	add    $0x10,%esp
80100216:	83 e8 01             	sub    $0x1,%eax
80100219:	85 c0                	test   %eax,%eax
8010021b:	89 43 50             	mov    %eax,0x50(%ebx)
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
80100220:	8b 43 58             	mov    0x58(%ebx),%eax
80100223:	8b 53 54             	mov    0x54(%ebx),%edx
80100226:	89 50 54             	mov    %edx,0x54(%eax)
80100229:	8b 43 54             	mov    0x54(%ebx),%eax
8010022c:	8b 53 58             	mov    0x58(%ebx),%edx
8010022f:	89 50 58             	mov    %edx,0x58(%eax)
80100232:	a1 b0 fd 10 80       	mov    0x8010fdb0,%eax
80100237:	c7 43 54 58 fd 10 80 	movl   $0x8010fd58,0x54(%ebx)
8010023e:	89 43 58             	mov    %eax,0x58(%ebx)
80100241:	a1 b0 fd 10 80       	mov    0x8010fdb0,%eax
80100246:	89 58 54             	mov    %ebx,0x54(%eax)
80100249:	89 1d b0 fd 10 80    	mov    %ebx,0x8010fdb0
8010024f:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
8010025c:	e9 3f 44 00 00       	jmp    801046a0 <release>
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 71 10 80       	push   $0x801071e6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010027f:	57                   	push   %edi
80100280:	e8 db 14 00 00       	call   80101760 <iunlock>
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 3f 43 00 00       	call   801045d0 <acquire>
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
801002a1:	8b 15 40 00 11 80    	mov    0x80110040,%edx
801002a7:	39 15 44 00 11 80    	cmp    %edx,0x80110044
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 40 00 11 80       	push   $0x80110040
801002c5:	e8 b6 3a 00 00       	call   80103d80 <sleep>
801002ca:	8b 15 40 00 11 80    	mov    0x80110040,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 44 00 11 80    	cmp    0x80110044,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
801002db:	e8 00 35 00 00       	call   801037e0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 ac 43 00 00       	call   801046a0 <release>
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 13 00 00       	call   80101680 <ilock>
801002fc:	83 c4 10             	add    $0x10,%esp
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 40 00 11 80       	mov    %eax,0x80110040
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 c0 ff 10 80 	movsbl -0x7fef0040(%eax),%eax
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
80100329:	83 c6 01             	add    $0x1,%esi
8010032c:	83 eb 01             	sub    $0x1,%ebx
8010032f:	83 f8 0a             	cmp    $0xa,%eax
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
80100335:	74 43                	je     8010037a <consoleread+0x10a>
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 4e 43 00 00       	call   801046a0 <release>
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 13 00 00       	call   80101680 <ilock>
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
80100372:	89 15 40 00 11 80    	mov    %edx,0x80110040
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
80100398:	fa                   	cli    
80100399:	c7 05 58 a5 10 80 00 	movl   $0x0,0x8010a558
801003a0:	00 00 00 
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
801003a9:	e8 82 23 00 00       	call   80102730 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 71 10 80       	push   $0x801071ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
801003c5:	c7 04 24 83 7c 10 80 	movl   $0x80107c83,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 d3 40 00 00       	call   801044b0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 72 10 80       	push   $0x80107201
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
801003f9:	c7 05 5c a5 10 80 01 	movl   $0x1,0x8010a55c
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
80100410:	8b 0d 5c a5 10 80    	mov    0x8010a55c,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 91 59 00 00       	call   80105dd0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
80100457:	0f b6 c0             	movzbl %al,%eax
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
8010046d:	09 fb                	or     %edi,%ebx
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 df 58 00 00       	call   80105dd0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 58 00 00       	call   80105dd0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 58 00 00       	call   80105dd0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
80100517:	83 eb 50             	sub    $0x50,%ebx
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 77 42 00 00       	call   801047a0 <memmove>
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 aa 41 00 00       	call   801046f0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 72 10 80       	push   $0x80107205
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
8010058b:	85 c9                	test   %ecx,%ecx
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 72 10 80 	movzbl -0x7fef8dd0(%edx),%edx
801005b8:	85 c0                	test   %eax,%eax
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 11 00 00       	call   80101760 <iunlock>
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 b0 3f 00 00       	call   801045d0 <acquire>
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 54 40 00 00       	call   801046a0 <release>
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 10 00 00       	call   80101680 <ilock>
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
80100669:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010066e:	85 c0                	test   %eax,%eax
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
8010068c:	31 db                	xor    %ebx,%ebx
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801006a0:	0f b6 16             	movzbl (%esi),%edx
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
801006fe:	0f b6 06             	movzbl (%esi),%eax
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 7c 3f 00 00       	call   801046a0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
80100787:	0f be 02             	movsbl (%edx),%eax
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
801007d0:	ba 18 72 10 80       	mov    $0x80107218,%edx
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 db 3d 00 00       	call   801045d0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 72 10 80       	push   $0x8010721f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
80100816:	31 f6                	xor    %esi,%esi
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 a8 3d 00 00       	call   801045d0 <acquire>
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
80100851:	a1 48 00 11 80       	mov    0x80110048,%eax
80100856:	3b 05 44 00 11 80    	cmp    0x80110044,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 48 00 11 80       	mov    %eax,0x80110048
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 13 3e 00 00       	call   801046a0 <release>
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 48 00 11 80       	mov    0x80110048,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 40 00 11 80    	sub    0x80110040,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
801008c5:	83 ff 0d             	cmp    $0xd,%edi
801008c8:	89 15 48 00 11 80    	mov    %edx,0x80110048
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 c0 ff 10 80    	mov    %cl,-0x7fef0040(%eax)
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 40 00 11 80       	mov    0x80110040,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 48 00 11 80    	cmp    %eax,0x80110048
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
80100909:	83 ec 0c             	sub    $0xc,%esp
8010090c:	a3 44 00 11 80       	mov    %eax,0x80110044
80100911:	68 40 00 11 80       	push   $0x80110040
80100916:	e8 15 36 00 00       	call   80103f30 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100938:	a1 48 00 11 80       	mov    0x80110048,%eax
8010093d:	39 05 44 00 11 80    	cmp    %eax,0x80110044
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100950:	a3 48 00 11 80       	mov    %eax,0x80110048
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
8010095f:	a1 48 00 11 80       	mov    0x80110048,%eax
80100964:	3b 05 44 00 11 80    	cmp    0x80110044,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
80100978:	80 ba c0 ff 10 80 0a 	cmpb   $0xa,-0x7fef0040(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
80100997:	e9 74 36 00 00       	jmp    80104010 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009a0:	c6 80 c0 ff 10 80 0a 	movb   $0xa,-0x7fef0040(%eax)
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 48 00 11 80       	mov    0x80110048,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
801009c6:	68 28 72 10 80       	push   $0x80107228
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 9b 3a 00 00       	call   80104470 <initlock>
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
801009db:	c7 05 0c 0a 11 80 00 	movl   $0x80100600,0x80110a0c
801009e2:	06 10 80 
801009e5:	c7 05 08 0a 11 80 70 	movl   $0x80100270,0x80110a08
801009ec:	02 10 80 
801009ef:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801009f6:	00 00 00 
801009f9:	e8 d2 18 00 00       	call   801022d0 <ioapicenable>
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
80100a1c:	e8 bf 2d 00 00       	call   801037e0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a27:	e8 74 21 00 00       	call   80102ba0 <begin_op>
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 a9 14 00 00       	call   80101ee0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0c 00 00       	call   80101680 <ilock>
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 02 0f 00 00       	call   80101960 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 a1 0e 00 00       	call   80101910 <iunlockput>
80100a6f:	e8 9c 21 00 00       	call   80102c10 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
80100a94:	e8 87 64 00 00       	call   80106f20 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
80100aa3:	31 ff                	xor    %edi,%edi
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 45 62 00 00       	call   80106d40 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 53 61 00 00       	call   80106c80 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 03 0e 00 00       	call   80101960 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 29 63 00 00       	call   80106ea0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 76 0d 00 00       	call   80101910 <iunlockput>
80100b9a:	e8 71 20 00 00       	call   80102c10 <end_op>
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 91 61 00 00       	call   80106d40 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 da 62 00 00       	call   80106ea0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
80100bd3:	e8 38 20 00 00       	call   80102c10 <end_op>
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 41 72 10 80       	push   $0x80107241
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 b5 63 00 00       	call   80106fc0 <clearpteu>
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 d2 3c 00 00       	call   80104910 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 bf 3c 00 00       	call   80104910 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 be 64 00 00       	call   80107120 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
80100c77:	83 c7 01             	add    $0x1,%edi
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
80100cb1:	29 c1                	sub    %eax,%ecx
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
80100cc7:	e8 54 64 00 00       	call   80107120 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 c1 3b 00 00       	call   801048d0 <safestrcpy>
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
80100d1d:	89 31                	mov    %esi,(%ecx)
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 b7 5d 00 00       	call   80106af0 <switchuvm>
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 5f 61 00 00       	call   80106ea0 <freevm>
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
80100d66:	68 4d 72 10 80       	push   $0x8010724d
80100d6b:	68 60 00 11 80       	push   $0x80110060
80100d70:	e8 fb 36 00 00       	call   80104470 <initlock>
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
80100d84:	bb 98 00 11 80       	mov    $0x80110098,%ebx
80100d89:	83 ec 10             	sub    $0x10,%esp
80100d8c:	68 60 00 11 80       	push   $0x80110060
80100d91:	e8 3a 38 00 00       	call   801045d0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb f8 09 11 80    	cmp    $0x801109f8,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
80100db2:	83 ec 0c             	sub    $0xc,%esp
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
80100dbc:	68 60 00 11 80       	push   $0x80110060
80100dc1:	e8 da 38 00 00       	call   801046a0 <release>
80100dc6:	89 d8                	mov    %ebx,%eax
80100dc8:	83 c4 10             	add    $0x10,%esp
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
80100dd0:	83 ec 0c             	sub    $0xc,%esp
80100dd3:	31 db                	xor    %ebx,%ebx
80100dd5:	68 60 00 11 80       	push   $0x80110060
80100dda:	e8 c1 38 00 00       	call   801046a0 <release>
80100ddf:	89 d8                	mov    %ebx,%eax
80100de1:	83 c4 10             	add    $0x10,%esp
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100dfa:	68 60 00 11 80       	push   $0x80110060
80100dff:	e8 cc 37 00 00       	call   801045d0 <acquire>
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
80100e0e:	83 c0 01             	add    $0x1,%eax
80100e11:	83 ec 0c             	sub    $0xc,%esp
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
80100e17:	68 60 00 11 80       	push   $0x80110060
80100e1c:	e8 7f 38 00 00       	call   801046a0 <release>
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 72 10 80       	push   $0x80107254
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100e4c:	68 60 00 11 80       	push   $0x80110060
80100e51:	e8 7a 37 00 00       	call   801045d0 <acquire>
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
80100e6e:	c7 45 08 60 00 11 80 	movl   $0x80110060,0x8(%ebp)
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
80100e7c:	e9 1f 38 00 00       	jmp    801046a0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
80100e8e:	83 ec 0c             	sub    $0xc,%esp
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
80100ea0:	68 60 00 11 80       	push   $0x80110060
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ea8:	e8 f3 37 00 00       	call   801046a0 <release>
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 7a 24 00 00       	call   80103350 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ee0:	e8 bb 1c 00 00       	call   80102ba0 <begin_op>
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 08 00 00       	call   801017b0 <iput>
80100ef0:	83 c4 10             	add    $0x10,%esp
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
80100efa:	e9 11 1d 00 00       	jmp    80102c10 <end_op>
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 5c 72 10 80       	push   $0x8010725c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 07 00 00       	call   80101680 <ilock>
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 f9 09 00 00       	call   80101930 <stati>
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 08 00 00       	call   80101760 <iunlock>
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 06 00 00       	call   80101680 <ilock>
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 c4 09 00 00       	call   80101960 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 07 00 00       	call   80101760 <iunlock>
80100fb3:	83 c4 10             	add    $0x10,%esp
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
80100fcd:	e9 2e 25 00 00       	jmp    80103500 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 66 72 10 80       	push   $0x80107266
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101029:	31 ff                	xor    %edi,%edi
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101038:	01 46 14             	add    %eax,0x14(%esi)
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101044:	e8 17 07 00 00       	call   80101760 <iunlock>
80101049:	e8 c2 1b 00 00       	call   80102c10 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
8010105c:	01 df                	add    %ebx,%edi
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
80101076:	e8 25 1b 00 00       	call   80102ba0 <begin_op>
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 05 00 00       	call   80101680 <ilock>
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 c8 09 00 00       	call   80101a60 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 06 00 00       	call   80101760 <iunlock>
801010ad:	e8 5e 1b 00 00       	call   80102c10 <end_op>
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
801010ed:	e9 fe 22 00 00       	jmp    801033f0 <pipewrite>
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 6f 72 10 80       	push   $0x8010726f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 75 72 10 80       	push   $0x80107275
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 78 0a 11 80    	add    0x80110a78,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
8010112a:	89 d9                	mov    %ebx,%ecx
8010112c:	c1 fb 03             	sar    $0x3,%ebx
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
80101140:	d3 e2                	shl    %cl,%edx
80101142:	0f b6 4c 18 60       	movzbl 0x60(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 60          	mov    %dl,0x60(%esi,%ebx,1)
80101158:	56                   	push   %esi
80101159:	e8 12 1c 00 00       	call   80102d70 <log_write>
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 7f 72 10 80       	push   $0x8010727f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
80101189:	8b 0d 60 0a 11 80    	mov    0x80110a60,%ecx
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 78 0a 11 80    	add    0x80110a78,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011be:	a1 60 0a 11 80       	mov    0x80110a60,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
801011d0:	89 c1                	mov    %eax,%ecx
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 60       	movzbl 0x60(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 60 0a 11 80    	cmp    %eax,0x80110a60
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 92 72 10 80       	push   $0x80107292
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101233:	83 ec 0c             	sub    $0xc,%esp
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 60          	mov    %dl,0x60(%edi,%ecx,1)
8010123c:	57                   	push   %edi
8010123d:	e8 2e 1b 00 00       	call   80102d70 <log_write>
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
80101257:	8d 40 60             	lea    0x60(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 86 34 00 00       	call   801046f0 <memset>
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 fe 1a 00 00       	call   80102d70 <log_write>
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
80101298:	31 f6                	xor    %esi,%esi
8010129a:	bb b8 0a 11 80       	mov    $0x80110ab8,%ebx
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801012a5:	68 80 0a 11 80       	push   $0x80110a80
801012aa:	e8 21 33 00 00       	call   801045d0 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801012c6:	81 fb a0 27 11 80    	cmp    $0x801127a0,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
801012e2:	81 c3 94 00 00 00    	add    $0x94,%ebx
801012e8:	81 fb a0 27 11 80    	cmp    $0x801127a0,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
801012f4:	83 ec 0c             	sub    $0xc,%esp
801012f7:	89 3e                	mov    %edi,(%esi)
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
80101303:	c7 46 50 00 00 00 00 	movl   $0x0,0x50(%esi)
8010130a:	68 80 0a 11 80       	push   $0x80110a80
8010130f:	e8 8c 33 00 00       	call   801046a0 <release>
80101314:	83 c4 10             	add    $0x10,%esp
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
8010132d:	83 ec 0c             	sub    $0xc,%esp
80101330:	83 c1 01             	add    $0x1,%ecx
80101333:	89 de                	mov    %ebx,%esi
80101335:	68 80 0a 11 80       	push   $0x80110a80
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
8010133d:	e8 5e 33 00 00       	call   801046a0 <release>
80101342:	83 c4 10             	add    $0x10,%esp
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 a8 72 10 80       	push   $0x801072a8
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101373:	8b 5f 60             	mov    0x60(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	74 76                	je     801013f0 <bmap+0x90>
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 d8                	mov    %ebx,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 90 00 00 00    	ja     80101424 <bmap+0xc4>
80101394:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
8010139a:	8b 00                	mov    (%eax),%eax
8010139c:	85 d2                	test   %edx,%edx
8010139e:	74 70                	je     80101410 <bmap+0xb0>
801013a0:	83 ec 08             	sub    $0x8,%esp
801013a3:	52                   	push   %edx
801013a4:	50                   	push   %eax
801013a5:	e8 26 ed ff ff       	call   801000d0 <bread>
801013aa:	8d 54 98 60          	lea    0x60(%eax,%ebx,4),%edx
801013ae:	83 c4 10             	add    $0x10,%esp
801013b1:	89 c7                	mov    %eax,%edi
801013b3:	8b 1a                	mov    (%edx),%ebx
801013b5:	85 db                	test   %ebx,%ebx
801013b7:	75 1d                	jne    801013d6 <bmap+0x76>
801013b9:	8b 06                	mov    (%esi),%eax
801013bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013be:	e8 bd fd ff ff       	call   80101180 <balloc>
801013c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013c6:	83 ec 0c             	sub    $0xc,%esp
801013c9:	89 c3                	mov    %eax,%ebx
801013cb:	89 02                	mov    %eax,(%edx)
801013cd:	57                   	push   %edi
801013ce:	e8 9d 19 00 00       	call   80102d70 <log_write>
801013d3:	83 c4 10             	add    $0x10,%esp
801013d6:	83 ec 0c             	sub    $0xc,%esp
801013d9:	57                   	push   %edi
801013da:	e8 01 ee ff ff       	call   801001e0 <brelse>
801013df:	83 c4 10             	add    $0x10,%esp
801013e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e5:	89 d8                	mov    %ebx,%eax
801013e7:	5b                   	pop    %ebx
801013e8:	5e                   	pop    %esi
801013e9:	5f                   	pop    %edi
801013ea:	5d                   	pop    %ebp
801013eb:	c3                   	ret    
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013f0:	8b 00                	mov    (%eax),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 47 60             	mov    %eax,0x60(%edi)
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013fd:	89 c3                	mov    %eax,%ebx
801013ff:	89 d8                	mov    %ebx,%eax
80101401:	5b                   	pop    %ebx
80101402:	5e                   	pop    %esi
80101403:	5f                   	pop    %edi
80101404:	5d                   	pop    %ebp
80101405:	c3                   	ret    
80101406:	8d 76 00             	lea    0x0(%esi),%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101410:	e8 6b fd ff ff       	call   80101180 <balloc>
80101415:	89 c2                	mov    %eax,%edx
80101417:	89 86 90 00 00 00    	mov    %eax,0x90(%esi)
8010141d:	8b 06                	mov    (%esi),%eax
8010141f:	e9 7c ff ff ff       	jmp    801013a0 <bmap+0x40>
80101424:	83 ec 0c             	sub    $0xc,%esp
80101427:	68 b8 72 10 80       	push   $0x801072b8
8010142c:	e8 5f ef ff ff       	call   80100390 <panic>
80101431:	eb 0d                	jmp    80101440 <readsb>
80101433:	90                   	nop
80101434:	90                   	nop
80101435:	90                   	nop
80101436:	90                   	nop
80101437:	90                   	nop
80101438:	90                   	nop
80101439:	90                   	nop
8010143a:	90                   	nop
8010143b:	90                   	nop
8010143c:	90                   	nop
8010143d:	90                   	nop
8010143e:	90                   	nop
8010143f:	90                   	nop

80101440 <readsb>:
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
80101457:	8d 40 60             	lea    0x60(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 3a 33 00 00       	call   801047a0 <memmove>
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb c4 0a 11 80       	mov    $0x80110ac4,%ebx
80101489:	83 ec 0c             	sub    $0xc,%esp
8010148c:	68 cb 72 10 80       	push   $0x801072cb
80101491:	68 80 0a 11 80       	push   $0x80110a80
80101496:	e8 d5 2f 00 00       	call   80104470 <initlock>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	66 90                	xchg   %ax,%ax
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	68 d2 72 10 80       	push   $0x801072d2
801014a8:	53                   	push   %ebx
801014a9:	81 c3 94 00 00 00    	add    $0x94,%ebx
801014af:	e8 8c 2e 00 00       	call   80104340 <initsleeplock>
801014b4:	83 c4 10             	add    $0x10,%esp
801014b7:	81 fb ac 27 11 80    	cmp    $0x801127ac,%ebx
801014bd:	75 e1                	jne    801014a0 <iinit+0x20>
801014bf:	83 ec 08             	sub    $0x8,%esp
801014c2:	68 60 0a 11 80       	push   $0x80110a60
801014c7:	ff 75 08             	pushl  0x8(%ebp)
801014ca:	e8 71 ff ff ff       	call   80101440 <readsb>
801014cf:	ff 35 78 0a 11 80    	pushl  0x80110a78
801014d5:	ff 35 74 0a 11 80    	pushl  0x80110a74
801014db:	ff 35 70 0a 11 80    	pushl  0x80110a70
801014e1:	ff 35 6c 0a 11 80    	pushl  0x80110a6c
801014e7:	ff 35 68 0a 11 80    	pushl  0x80110a68
801014ed:	ff 35 64 0a 11 80    	pushl  0x80110a64
801014f3:	ff 35 60 0a 11 80    	pushl  0x80110a60
801014f9:	68 38 73 10 80       	push   $0x80107338
801014fe:	e8 5d f1 ff ff       	call   80100660 <cprintf>
80101503:	83 c4 30             	add    $0x30,%esp
80101506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101509:	c9                   	leave  
8010150a:	c3                   	ret    
8010150b:	90                   	nop
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <ialloc>:
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 1c             	sub    $0x1c,%esp
80101519:	83 3d 68 0a 11 80 01 	cmpl   $0x1,0x80110a68
80101520:	8b 45 0c             	mov    0xc(%ebp),%eax
80101523:	8b 75 08             	mov    0x8(%ebp),%esi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101529:	0f 86 91 00 00 00    	jbe    801015c0 <ialloc+0xb0>
8010152f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101534:	eb 21                	jmp    80101557 <ialloc+0x47>
80101536:	8d 76 00             	lea    0x0(%esi),%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101540:	83 ec 0c             	sub    $0xc,%esp
80101543:	83 c3 01             	add    $0x1,%ebx
80101546:	57                   	push   %edi
80101547:	e8 94 ec ff ff       	call   801001e0 <brelse>
8010154c:	83 c4 10             	add    $0x10,%esp
8010154f:	39 1d 68 0a 11 80    	cmp    %ebx,0x80110a68
80101555:	76 69                	jbe    801015c0 <ialloc+0xb0>
80101557:	89 d8                	mov    %ebx,%eax
80101559:	83 ec 08             	sub    $0x8,%esp
8010155c:	c1 e8 03             	shr    $0x3,%eax
8010155f:	03 05 74 0a 11 80    	add    0x80110a74,%eax
80101565:	50                   	push   %eax
80101566:	56                   	push   %esi
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c7                	mov    %eax,%edi
8010156e:	89 d8                	mov    %ebx,%eax
80101570:	83 c4 10             	add    $0x10,%esp
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	c1 e0 06             	shl    $0x6,%eax
80101579:	8d 4c 07 60          	lea    0x60(%edi,%eax,1),%ecx
8010157d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101581:	75 bd                	jne    80101540 <ialloc+0x30>
80101583:	83 ec 04             	sub    $0x4,%esp
80101586:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101589:	6a 40                	push   $0x40
8010158b:	6a 00                	push   $0x0
8010158d:	51                   	push   %ecx
8010158e:	e8 5d 31 00 00       	call   801046f0 <memset>
80101593:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101597:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010159a:	66 89 01             	mov    %ax,(%ecx)
8010159d:	89 3c 24             	mov    %edi,(%esp)
801015a0:	e8 cb 17 00 00       	call   80102d70 <log_write>
801015a5:	89 3c 24             	mov    %edi,(%esp)
801015a8:	e8 33 ec ff ff       	call   801001e0 <brelse>
801015ad:	83 c4 10             	add    $0x10,%esp
801015b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b3:	89 da                	mov    %ebx,%edx
801015b5:	89 f0                	mov    %esi,%eax
801015b7:	5b                   	pop    %ebx
801015b8:	5e                   	pop    %esi
801015b9:	5f                   	pop    %edi
801015ba:	5d                   	pop    %ebp
801015bb:	e9 d0 fc ff ff       	jmp    80101290 <iget>
801015c0:	83 ec 0c             	sub    $0xc,%esp
801015c3:	68 d8 72 10 80       	push   $0x801072d8
801015c8:	e8 c3 ed ff ff       	call   80100390 <panic>
801015cd:	8d 76 00             	lea    0x0(%esi),%esi

801015d0 <iupdate>:
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	56                   	push   %esi
801015d4:	53                   	push   %ebx
801015d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801015d8:	83 ec 08             	sub    $0x8,%esp
801015db:	8b 43 04             	mov    0x4(%ebx),%eax
801015de:	83 c3 60             	add    $0x60,%ebx
801015e1:	c1 e8 03             	shr    $0x3,%eax
801015e4:	03 05 74 0a 11 80    	add    0x80110a74,%eax
801015ea:	50                   	push   %eax
801015eb:	ff 73 a0             	pushl  -0x60(%ebx)
801015ee:	e8 dd ea ff ff       	call   801000d0 <bread>
801015f3:	89 c6                	mov    %eax,%esi
801015f5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801015f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
801015fc:	83 c4 0c             	add    $0xc,%esp
801015ff:	83 e0 07             	and    $0x7,%eax
80101602:	c1 e0 06             	shl    $0x6,%eax
80101605:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
80101609:	66 89 10             	mov    %dx,(%eax)
8010160c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
80101610:	83 c0 0c             	add    $0xc,%eax
80101613:	66 89 50 f6          	mov    %dx,-0xa(%eax)
80101617:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010161b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
8010161f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101623:	66 89 50 fa          	mov    %dx,-0x6(%eax)
80101627:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010162a:	89 50 fc             	mov    %edx,-0x4(%eax)
8010162d:	6a 34                	push   $0x34
8010162f:	53                   	push   %ebx
80101630:	50                   	push   %eax
80101631:	e8 6a 31 00 00       	call   801047a0 <memmove>
80101636:	89 34 24             	mov    %esi,(%esp)
80101639:	e8 32 17 00 00       	call   80102d70 <log_write>
8010163e:	89 75 08             	mov    %esi,0x8(%ebp)
80101641:	83 c4 10             	add    $0x10,%esp
80101644:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5d                   	pop    %ebp
8010164a:	e9 91 eb ff ff       	jmp    801001e0 <brelse>
8010164f:	90                   	nop

80101650 <idup>:
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	53                   	push   %ebx
80101654:	83 ec 10             	sub    $0x10,%esp
80101657:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010165a:	68 80 0a 11 80       	push   $0x80110a80
8010165f:	e8 6c 2f 00 00       	call   801045d0 <acquire>
80101664:	83 43 08 01          	addl   $0x1,0x8(%ebx)
80101668:	c7 04 24 80 0a 11 80 	movl   $0x80110a80,(%esp)
8010166f:	e8 2c 30 00 00       	call   801046a0 <release>
80101674:	89 d8                	mov    %ebx,%eax
80101676:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101679:	c9                   	leave  
8010167a:	c3                   	ret    
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <ilock>:
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101688:	85 db                	test   %ebx,%ebx
8010168a:	0f 84 b7 00 00 00    	je     80101747 <ilock+0xc7>
80101690:	8b 53 08             	mov    0x8(%ebx),%edx
80101693:	85 d2                	test   %edx,%edx
80101695:	0f 8e ac 00 00 00    	jle    80101747 <ilock+0xc7>
8010169b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	50                   	push   %eax
801016a2:	e8 d9 2c 00 00       	call   80104380 <acquiresleep>
801016a7:	8b 43 50             	mov    0x50(%ebx),%eax
801016aa:	83 c4 10             	add    $0x10,%esp
801016ad:	85 c0                	test   %eax,%eax
801016af:	74 0f                	je     801016c0 <ilock+0x40>
801016b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b4:	5b                   	pop    %ebx
801016b5:	5e                   	pop    %esi
801016b6:	5d                   	pop    %ebp
801016b7:	c3                   	ret    
801016b8:	90                   	nop
801016b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016c0:	8b 43 04             	mov    0x4(%ebx),%eax
801016c3:	83 ec 08             	sub    $0x8,%esp
801016c6:	c1 e8 03             	shr    $0x3,%eax
801016c9:	03 05 74 0a 11 80    	add    0x80110a74,%eax
801016cf:	50                   	push   %eax
801016d0:	ff 33                	pushl  (%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
801016d7:	89 c6                	mov    %eax,%esi
801016d9:	8b 43 04             	mov    0x4(%ebx),%eax
801016dc:	83 c4 0c             	add    $0xc,%esp
801016df:	83 e0 07             	and    $0x7,%eax
801016e2:	c1 e0 06             	shl    $0x6,%eax
801016e5:	8d 44 06 60          	lea    0x60(%esi,%eax,1),%eax
801016e9:	0f b7 10             	movzwl (%eax),%edx
801016ec:	83 c0 0c             	add    $0xc,%eax
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
801016f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
801016fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ff:	66 89 53 58          	mov    %dx,0x58(%ebx)
80101703:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101707:	66 89 53 5a          	mov    %dx,0x5a(%ebx)
8010170b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010170e:	89 53 5c             	mov    %edx,0x5c(%ebx)
80101711:	6a 34                	push   $0x34
80101713:	50                   	push   %eax
80101714:	8d 43 60             	lea    0x60(%ebx),%eax
80101717:	50                   	push   %eax
80101718:	e8 83 30 00 00       	call   801047a0 <memmove>
8010171d:	89 34 24             	mov    %esi,(%esp)
80101720:	e8 bb ea ff ff       	call   801001e0 <brelse>
80101725:	83 c4 10             	add    $0x10,%esp
80101728:	66 83 7b 54 00       	cmpw   $0x0,0x54(%ebx)
8010172d:	c7 43 50 01 00 00 00 	movl   $0x1,0x50(%ebx)
80101734:	0f 85 77 ff ff ff    	jne    801016b1 <ilock+0x31>
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 f0 72 10 80       	push   $0x801072f0
80101742:	e8 49 ec ff ff       	call   80100390 <panic>
80101747:	83 ec 0c             	sub    $0xc,%esp
8010174a:	68 ea 72 10 80       	push   $0x801072ea
8010174f:	e8 3c ec ff ff       	call   80100390 <panic>
80101754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010175a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101760 <iunlock>:
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101768:	85 db                	test   %ebx,%ebx
8010176a:	74 28                	je     80101794 <iunlock+0x34>
8010176c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	56                   	push   %esi
80101773:	e8 a8 2c 00 00       	call   80104420 <holdingsleep>
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 c0                	test   %eax,%eax
8010177d:	74 15                	je     80101794 <iunlock+0x34>
8010177f:	8b 43 08             	mov    0x8(%ebx),%eax
80101782:	85 c0                	test   %eax,%eax
80101784:	7e 0e                	jle    80101794 <iunlock+0x34>
80101786:	89 75 08             	mov    %esi,0x8(%ebp)
80101789:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010178c:	5b                   	pop    %ebx
8010178d:	5e                   	pop    %esi
8010178e:	5d                   	pop    %ebp
8010178f:	e9 4c 2c 00 00       	jmp    801043e0 <releasesleep>
80101794:	83 ec 0c             	sub    $0xc,%esp
80101797:	68 ff 72 10 80       	push   $0x801072ff
8010179c:	e8 ef eb ff ff       	call   80100390 <panic>
801017a1:	eb 0d                	jmp    801017b0 <iput>
801017a3:	90                   	nop
801017a4:	90                   	nop
801017a5:	90                   	nop
801017a6:	90                   	nop
801017a7:	90                   	nop
801017a8:	90                   	nop
801017a9:	90                   	nop
801017aa:	90                   	nop
801017ab:	90                   	nop
801017ac:	90                   	nop
801017ad:	90                   	nop
801017ae:	90                   	nop
801017af:	90                   	nop

801017b0 <iput>:
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 28             	sub    $0x28,%esp
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801017bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017bf:	57                   	push   %edi
801017c0:	e8 bb 2b 00 00       	call   80104380 <acquiresleep>
801017c5:	8b 53 50             	mov    0x50(%ebx),%edx
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	85 d2                	test   %edx,%edx
801017cd:	74 07                	je     801017d6 <iput+0x26>
801017cf:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
801017d4:	74 32                	je     80101808 <iput+0x58>
801017d6:	83 ec 0c             	sub    $0xc,%esp
801017d9:	57                   	push   %edi
801017da:	e8 01 2c 00 00       	call   801043e0 <releasesleep>
801017df:	c7 04 24 80 0a 11 80 	movl   $0x80110a80,(%esp)
801017e6:	e8 e5 2d 00 00       	call   801045d0 <acquire>
801017eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
801017ef:	83 c4 10             	add    $0x10,%esp
801017f2:	c7 45 08 80 0a 11 80 	movl   $0x80110a80,0x8(%ebp)
801017f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5f                   	pop    %edi
801017ff:	5d                   	pop    %ebp
80101800:	e9 9b 2e 00 00       	jmp    801046a0 <release>
80101805:	8d 76 00             	lea    0x0(%esi),%esi
80101808:	83 ec 0c             	sub    $0xc,%esp
8010180b:	68 80 0a 11 80       	push   $0x80110a80
80101810:	e8 bb 2d 00 00       	call   801045d0 <acquire>
80101815:	8b 73 08             	mov    0x8(%ebx),%esi
80101818:	c7 04 24 80 0a 11 80 	movl   $0x80110a80,(%esp)
8010181f:	e8 7c 2e 00 00       	call   801046a0 <release>
80101824:	83 c4 10             	add    $0x10,%esp
80101827:	83 fe 01             	cmp    $0x1,%esi
8010182a:	75 aa                	jne    801017d6 <iput+0x26>
8010182c:	8d 8b 90 00 00 00    	lea    0x90(%ebx),%ecx
80101832:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101835:	8d 73 60             	lea    0x60(%ebx),%esi
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x97>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c6 04             	add    $0x4,%esi
80101843:	39 fe                	cmp    %edi,%esi
80101845:	74 19                	je     80101860 <iput+0xb0>
80101847:	8b 16                	mov    (%esi),%edx
80101849:	85 d2                	test   %edx,%edx
8010184b:	74 f3                	je     80101840 <iput+0x90>
8010184d:	8b 03                	mov    (%ebx),%eax
8010184f:	e8 bc f8 ff ff       	call   80101110 <bfree>
80101854:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010185a:	eb e4                	jmp    80101840 <iput+0x90>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 33                	jne    801018a0 <iput+0xf0>
8010186d:	83 ec 0c             	sub    $0xc,%esp
80101870:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
80101877:	53                   	push   %ebx
80101878:	e8 53 fd ff ff       	call   801015d0 <iupdate>
8010187d:	31 c0                	xor    %eax,%eax
8010187f:	66 89 43 54          	mov    %ax,0x54(%ebx)
80101883:	89 1c 24             	mov    %ebx,(%esp)
80101886:	e8 45 fd ff ff       	call   801015d0 <iupdate>
8010188b:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
80101892:	83 c4 10             	add    $0x10,%esp
80101895:	e9 3c ff ff ff       	jmp    801017d6 <iput+0x26>
8010189a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801018a0:	83 ec 08             	sub    $0x8,%esp
801018a3:	50                   	push   %eax
801018a4:	ff 33                	pushl  (%ebx)
801018a6:	e8 25 e8 ff ff       	call   801000d0 <bread>
801018ab:	8d 88 60 02 00 00    	lea    0x260(%eax),%ecx
801018b1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801018b7:	8d 70 60             	lea    0x60(%eax),%esi
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	89 cf                	mov    %ecx,%edi
801018bf:	eb 0e                	jmp    801018cf <iput+0x11f>
801018c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018c8:	83 c6 04             	add    $0x4,%esi
801018cb:	39 fe                	cmp    %edi,%esi
801018cd:	74 0f                	je     801018de <iput+0x12e>
801018cf:	8b 16                	mov    (%esi),%edx
801018d1:	85 d2                	test   %edx,%edx
801018d3:	74 f3                	je     801018c8 <iput+0x118>
801018d5:	8b 03                	mov    (%ebx),%eax
801018d7:	e8 34 f8 ff ff       	call   80101110 <bfree>
801018dc:	eb ea                	jmp    801018c8 <iput+0x118>
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
801018ec:	8b 93 90 00 00 00    	mov    0x90(%ebx),%edx
801018f2:	8b 03                	mov    (%ebx),%eax
801018f4:	e8 17 f8 ff ff       	call   80101110 <bfree>
801018f9:	c7 83 90 00 00 00 00 	movl   $0x0,0x90(%ebx)
80101900:	00 00 00 
80101903:	83 c4 10             	add    $0x10,%esp
80101906:	e9 62 ff ff ff       	jmp    8010186d <iput+0xbd>
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <iunlockput>:
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 10             	sub    $0x10,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010191a:	53                   	push   %ebx
8010191b:	e8 40 fe ff ff       	call   80101760 <iunlock>
80101920:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
8010192a:	e9 81 fe ff ff       	jmp    801017b0 <iput>
8010192f:	90                   	nop

80101930 <stati>:
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
80101944:	0f b7 4a 54          	movzwl 0x54(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
8010194b:	0f b7 4a 5a          	movzwl 0x5a(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
80101953:	8b 52 5c             	mov    0x5c(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 1c             	sub    $0x1c,%esp
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010196f:	8b 7d 14             	mov    0x14(%ebp),%edi
80101972:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
80101977:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010197a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010197d:	8b 75 10             	mov    0x10(%ebp),%esi
80101980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101983:	0f 84 a7 00 00 00    	je     80101a30 <readi+0xd0>
80101989:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010198c:	8b 40 5c             	mov    0x5c(%eax),%eax
8010198f:	39 c6                	cmp    %eax,%esi
80101991:	0f 87 ba 00 00 00    	ja     80101a51 <readi+0xf1>
80101997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010199a:	89 f9                	mov    %edi,%ecx
8010199c:	01 f1                	add    %esi,%ecx
8010199e:	0f 82 ad 00 00 00    	jb     80101a51 <readi+0xf1>
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	29 f2                	sub    %esi,%edx
801019a8:	39 c8                	cmp    %ecx,%eax
801019aa:	0f 43 d7             	cmovae %edi,%edx
801019ad:	31 ff                	xor    %edi,%edi
801019af:	85 d2                	test   %edx,%edx
801019b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801019b4:	74 6c                	je     80101a22 <readi+0xc2>
801019b6:	8d 76 00             	lea    0x0(%esi),%esi
801019b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801019c0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019c3:	89 f2                	mov    %esi,%edx
801019c5:	c1 ea 09             	shr    $0x9,%edx
801019c8:	89 d8                	mov    %ebx,%eax
801019ca:	e8 91 f9 ff ff       	call   80101360 <bmap>
801019cf:	83 ec 08             	sub    $0x8,%esp
801019d2:	50                   	push   %eax
801019d3:	ff 33                	pushl  (%ebx)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
801019da:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019dd:	89 c2                	mov    %eax,%edx
801019df:	89 f0                	mov    %esi,%eax
801019e1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019eb:	83 c4 0c             	add    $0xc,%esp
801019ee:	29 c1                	sub    %eax,%ecx
801019f0:	8d 44 02 60          	lea    0x60(%edx,%eax,1),%eax
801019f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019f7:	29 fb                	sub    %edi,%ebx
801019f9:	39 d9                	cmp    %ebx,%ecx
801019fb:	0f 46 d9             	cmovbe %ecx,%ebx
801019fe:	53                   	push   %ebx
801019ff:	50                   	push   %eax
80101a00:	01 df                	add    %ebx,%edi
80101a02:	ff 75 e0             	pushl  -0x20(%ebp)
80101a05:	01 de                	add    %ebx,%esi
80101a07:	e8 94 2d 00 00       	call   801047a0 <memmove>
80101a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a0f:	89 14 24             	mov    %edx,(%esp)
80101a12:	e8 c9 e7 ff ff       	call   801001e0 <brelse>
80101a17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a20:	77 9e                	ja     801019c0 <readi+0x60>
80101a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a28:	5b                   	pop    %ebx
80101a29:	5e                   	pop    %esi
80101a2a:	5f                   	pop    %edi
80101a2b:	5d                   	pop    %ebp
80101a2c:	c3                   	ret    
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
80101a30:	0f bf 40 56          	movswl 0x56(%eax),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 17                	ja     80101a51 <readi+0xf1>
80101a3a:	8b 04 c5 00 0a 11 80 	mov    -0x7feef600(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 0c                	je     80101a51 <readi+0xf1>
80101a45:	89 7d 10             	mov    %edi,0x10(%ebp)
80101a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a4b:	5b                   	pop    %ebx
80101a4c:	5e                   	pop    %esi
80101a4d:	5f                   	pop    %edi
80101a4e:	5d                   	pop    %ebp
80101a4f:	ff e0                	jmp    *%eax
80101a51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a56:	eb cd                	jmp    80101a25 <readi+0xc5>
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a60 <writei>:
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 1c             	sub    $0x1c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 7d 14             	mov    0x14(%ebp),%edi
80101a72:	66 83 78 54 03       	cmpw   $0x3,0x54(%eax)
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a7d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a80:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 5c             	cmp    %esi,0x5c(%eax)
80101a8f:	0f 82 eb 00 00 00    	jb     80101b80 <writei+0x120>
80101a95:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a98:	31 d2                	xor    %edx,%edx
80101a9a:	89 f8                	mov    %edi,%eax
80101a9c:	01 f0                	add    %esi,%eax
80101a9e:	0f 92 c2             	setb   %dl
80101aa1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa6:	0f 87 d4 00 00 00    	ja     80101b80 <writei+0x120>
80101aac:	85 d2                	test   %edx,%edx
80101aae:	0f 85 cc 00 00 00    	jne    80101b80 <writei+0x120>
80101ab4:	85 ff                	test   %edi,%edi
80101ab6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101abd:	74 72                	je     80101b31 <writei+0xd1>
80101abf:	90                   	nop
80101ac0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 f8                	mov    %edi,%eax
80101aca:	e8 91 f8 ff ff       	call   80101360 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 37                	pushl  (%edi)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
80101ada:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101add:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
80101ae0:	89 c7                	mov    %eax,%edi
80101ae2:	89 f0                	mov    %esi,%eax
80101ae4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae9:	83 c4 0c             	add    $0xc,%esp
80101aec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101af1:	29 c1                	sub    %eax,%ecx
80101af3:	8d 44 07 60          	lea    0x60(%edi,%eax,1),%eax
80101af7:	39 d9                	cmp    %ebx,%ecx
80101af9:	0f 46 d9             	cmovbe %ecx,%ebx
80101afc:	53                   	push   %ebx
80101afd:	ff 75 dc             	pushl  -0x24(%ebp)
80101b00:	01 de                	add    %ebx,%esi
80101b02:	50                   	push   %eax
80101b03:	e8 98 2c 00 00       	call   801047a0 <memmove>
80101b08:	89 3c 24             	mov    %edi,(%esp)
80101b0b:	e8 60 12 00 00       	call   80102d70 <log_write>
80101b10:	89 3c 24             	mov    %edi,(%esp)
80101b13:	e8 c8 e6 ff ff       	call   801001e0 <brelse>
80101b18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b27:	77 97                	ja     80101ac0 <writei+0x60>
80101b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2c:	3b 70 5c             	cmp    0x5c(%eax),%esi
80101b2f:	77 37                	ja     80101b68 <writei+0x108>
80101b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b37:	5b                   	pop    %ebx
80101b38:	5e                   	pop    %esi
80101b39:	5f                   	pop    %edi
80101b3a:	5d                   	pop    %ebp
80101b3b:	c3                   	ret    
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b40:	0f bf 40 56          	movswl 0x56(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 36                	ja     80101b80 <writei+0x120>
80101b4a:	8b 04 c5 04 0a 11 80 	mov    -0x7feef5fc(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 2b                	je     80101b80 <writei+0x120>
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6b:	83 ec 0c             	sub    $0xc,%esp
80101b6e:	89 70 5c             	mov    %esi,0x5c(%eax)
80101b71:	50                   	push   %eax
80101b72:	e8 59 fa ff ff       	call   801015d0 <iupdate>
80101b77:	83 c4 10             	add    $0x10,%esp
80101b7a:	eb b5                	jmp    80101b31 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b85:	eb ad                	jmp    80101b34 <writei+0xd4>
80101b87:	89 f6                	mov    %esi,%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 0c             	sub    $0xc,%esp
80101b96:	6a 0e                	push   $0xe
80101b98:	ff 75 0c             	pushl  0xc(%ebp)
80101b9b:	ff 75 08             	pushl  0x8(%ebp)
80101b9e:	e8 6d 2c 00 00       	call   80104810 <strncmp>
80101ba3:	c9                   	leave  
80101ba4:	c3                   	ret    
80101ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101bbc:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80101bc1:	0f 85 85 00 00 00    	jne    80101c4c <dirlookup+0x9c>
80101bc7:	8b 53 5c             	mov    0x5c(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	74 3e                	je     80101c11 <dirlookup+0x61>
80101bd3:	90                   	nop
80101bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bd8:	6a 10                	push   $0x10
80101bda:	57                   	push   %edi
80101bdb:	56                   	push   %esi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 7e fd ff ff       	call   80101960 <readi>
80101be2:	83 c4 10             	add    $0x10,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 55                	jne    80101c3f <dirlookup+0x8f>
80101bea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bef:	74 18                	je     80101c09 <dirlookup+0x59>
80101bf1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bf4:	83 ec 04             	sub    $0x4,%esp
80101bf7:	6a 0e                	push   $0xe
80101bf9:	50                   	push   %eax
80101bfa:	ff 75 0c             	pushl  0xc(%ebp)
80101bfd:	e8 0e 2c 00 00       	call   80104810 <strncmp>
80101c02:	83 c4 10             	add    $0x10,%esp
80101c05:	85 c0                	test   %eax,%eax
80101c07:	74 17                	je     80101c20 <dirlookup+0x70>
80101c09:	83 c7 10             	add    $0x10,%edi
80101c0c:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80101c0f:	72 c7                	jb     80101bd8 <dirlookup+0x28>
80101c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c14:	31 c0                	xor    %eax,%eax
80101c16:	5b                   	pop    %ebx
80101c17:	5e                   	pop    %esi
80101c18:	5f                   	pop    %edi
80101c19:	5d                   	pop    %ebp
80101c1a:	c3                   	ret    
80101c1b:	90                   	nop
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c20:	8b 45 10             	mov    0x10(%ebp),%eax
80101c23:	85 c0                	test   %eax,%eax
80101c25:	74 05                	je     80101c2c <dirlookup+0x7c>
80101c27:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2a:	89 38                	mov    %edi,(%eax)
80101c2c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c30:	8b 03                	mov    (%ebx),%eax
80101c32:	e8 59 f6 ff ff       	call   80101290 <iget>
80101c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3a:	5b                   	pop    %ebx
80101c3b:	5e                   	pop    %esi
80101c3c:	5f                   	pop    %edi
80101c3d:	5d                   	pop    %ebp
80101c3e:	c3                   	ret    
80101c3f:	83 ec 0c             	sub    $0xc,%esp
80101c42:	68 19 73 10 80       	push   $0x80107319
80101c47:	e8 44 e7 ff ff       	call   80100390 <panic>
80101c4c:	83 ec 0c             	sub    $0xc,%esp
80101c4f:	68 07 73 10 80       	push   $0x80107307
80101c54:	e8 37 e7 ff ff       	call   80100390 <panic>
80101c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c60 <namex>:
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	89 cf                	mov    %ecx,%edi
80101c68:	89 c3                	mov    %eax,%ebx
80101c6a:	83 ec 1c             	sub    $0x1c,%esp
80101c6d:	80 38 2f             	cmpb   $0x2f,(%eax)
80101c70:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101c73:	0f 84 67 01 00 00    	je     80101de0 <namex+0x180>
80101c79:	e8 62 1b 00 00       	call   801037e0 <myproc>
80101c7e:	83 ec 0c             	sub    $0xc,%esp
80101c81:	8b 70 68             	mov    0x68(%eax),%esi
80101c84:	68 80 0a 11 80       	push   $0x80110a80
80101c89:	e8 42 29 00 00       	call   801045d0 <acquire>
80101c8e:	83 46 08 01          	addl   $0x1,0x8(%esi)
80101c92:	c7 04 24 80 0a 11 80 	movl   $0x80110a80,(%esp)
80101c99:	e8 02 2a 00 00       	call   801046a0 <release>
80101c9e:	83 c4 10             	add    $0x10,%esp
80101ca1:	eb 08                	jmp    80101cab <namex+0x4b>
80101ca3:	90                   	nop
80101ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ca8:	83 c3 01             	add    $0x1,%ebx
80101cab:	0f b6 03             	movzbl (%ebx),%eax
80101cae:	3c 2f                	cmp    $0x2f,%al
80101cb0:	74 f6                	je     80101ca8 <namex+0x48>
80101cb2:	84 c0                	test   %al,%al
80101cb4:	0f 84 ee 00 00 00    	je     80101da8 <namex+0x148>
80101cba:	0f b6 03             	movzbl (%ebx),%eax
80101cbd:	3c 2f                	cmp    $0x2f,%al
80101cbf:	0f 84 b3 00 00 00    	je     80101d78 <namex+0x118>
80101cc5:	84 c0                	test   %al,%al
80101cc7:	89 da                	mov    %ebx,%edx
80101cc9:	75 09                	jne    80101cd4 <namex+0x74>
80101ccb:	e9 a8 00 00 00       	jmp    80101d78 <namex+0x118>
80101cd0:	84 c0                	test   %al,%al
80101cd2:	74 0a                	je     80101cde <namex+0x7e>
80101cd4:	83 c2 01             	add    $0x1,%edx
80101cd7:	0f b6 02             	movzbl (%edx),%eax
80101cda:	3c 2f                	cmp    $0x2f,%al
80101cdc:	75 f2                	jne    80101cd0 <namex+0x70>
80101cde:	89 d1                	mov    %edx,%ecx
80101ce0:	29 d9                	sub    %ebx,%ecx
80101ce2:	83 f9 0d             	cmp    $0xd,%ecx
80101ce5:	0f 8e 91 00 00 00    	jle    80101d7c <namex+0x11c>
80101ceb:	83 ec 04             	sub    $0x4,%esp
80101cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cf1:	6a 0e                	push   $0xe
80101cf3:	53                   	push   %ebx
80101cf4:	57                   	push   %edi
80101cf5:	e8 a6 2a 00 00       	call   801047a0 <memmove>
80101cfa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cfd:	83 c4 10             	add    $0x10,%esp
80101d00:	89 d3                	mov    %edx,%ebx
80101d02:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d05:	75 11                	jne    80101d18 <namex+0xb8>
80101d07:	89 f6                	mov    %esi,%esi
80101d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101d10:	83 c3 01             	add    $0x1,%ebx
80101d13:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d16:	74 f8                	je     80101d10 <namex+0xb0>
80101d18:	83 ec 0c             	sub    $0xc,%esp
80101d1b:	56                   	push   %esi
80101d1c:	e8 5f f9 ff ff       	call   80101680 <ilock>
80101d21:	83 c4 10             	add    $0x10,%esp
80101d24:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
80101d29:	0f 85 91 00 00 00    	jne    80101dc0 <namex+0x160>
80101d2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d32:	85 d2                	test   %edx,%edx
80101d34:	74 09                	je     80101d3f <namex+0xdf>
80101d36:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d39:	0f 84 b7 00 00 00    	je     80101df6 <namex+0x196>
80101d3f:	83 ec 04             	sub    $0x4,%esp
80101d42:	6a 00                	push   $0x0
80101d44:	57                   	push   %edi
80101d45:	56                   	push   %esi
80101d46:	e8 65 fe ff ff       	call   80101bb0 <dirlookup>
80101d4b:	83 c4 10             	add    $0x10,%esp
80101d4e:	85 c0                	test   %eax,%eax
80101d50:	74 6e                	je     80101dc0 <namex+0x160>
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d58:	56                   	push   %esi
80101d59:	e8 02 fa ff ff       	call   80101760 <iunlock>
80101d5e:	89 34 24             	mov    %esi,(%esp)
80101d61:	e8 4a fa ff ff       	call   801017b0 <iput>
80101d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d69:	83 c4 10             	add    $0x10,%esp
80101d6c:	89 c6                	mov    %eax,%esi
80101d6e:	e9 38 ff ff ff       	jmp    80101cab <namex+0x4b>
80101d73:	90                   	nop
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d78:	89 da                	mov    %ebx,%edx
80101d7a:	31 c9                	xor    %ecx,%ecx
80101d7c:	83 ec 04             	sub    $0x4,%esp
80101d7f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d85:	51                   	push   %ecx
80101d86:	53                   	push   %ebx
80101d87:	57                   	push   %edi
80101d88:	e8 13 2a 00 00       	call   801047a0 <memmove>
80101d8d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d9a:	89 d3                	mov    %edx,%ebx
80101d9c:	e9 61 ff ff ff       	jmp    80101d02 <namex+0xa2>
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dab:	85 c0                	test   %eax,%eax
80101dad:	75 5d                	jne    80101e0c <namex+0x1ac>
80101daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101db2:	89 f0                	mov    %esi,%eax
80101db4:	5b                   	pop    %ebx
80101db5:	5e                   	pop    %esi
80101db6:	5f                   	pop    %edi
80101db7:	5d                   	pop    %ebp
80101db8:	c3                   	ret    
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	56                   	push   %esi
80101dc4:	e8 97 f9 ff ff       	call   80101760 <iunlock>
80101dc9:	89 34 24             	mov    %esi,(%esp)
80101dcc:	31 f6                	xor    %esi,%esi
80101dce:	e8 dd f9 ff ff       	call   801017b0 <iput>
80101dd3:	83 c4 10             	add    $0x10,%esp
80101dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd9:	89 f0                	mov    %esi,%eax
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
80101de0:	ba 01 00 00 00       	mov    $0x1,%edx
80101de5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dea:	e8 a1 f4 ff ff       	call   80101290 <iget>
80101def:	89 c6                	mov    %eax,%esi
80101df1:	e9 b5 fe ff ff       	jmp    80101cab <namex+0x4b>
80101df6:	83 ec 0c             	sub    $0xc,%esp
80101df9:	56                   	push   %esi
80101dfa:	e8 61 f9 ff ff       	call   80101760 <iunlock>
80101dff:	83 c4 10             	add    $0x10,%esp
80101e02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e05:	89 f0                	mov    %esi,%eax
80101e07:	5b                   	pop    %ebx
80101e08:	5e                   	pop    %esi
80101e09:	5f                   	pop    %edi
80101e0a:	5d                   	pop    %ebp
80101e0b:	c3                   	ret    
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	56                   	push   %esi
80101e10:	31 f6                	xor    %esi,%esi
80101e12:	e8 99 f9 ff ff       	call   801017b0 <iput>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb 93                	jmp    80101daf <namex+0x14f>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e20 <dirlink>:
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 20             	sub    $0x20,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101e2c:	6a 00                	push   $0x0
80101e2e:	ff 75 0c             	pushl  0xc(%ebp)
80101e31:	53                   	push   %ebx
80101e32:	e8 79 fd ff ff       	call   80101bb0 <dirlookup>
80101e37:	83 c4 10             	add    $0x10,%esp
80101e3a:	85 c0                	test   %eax,%eax
80101e3c:	75 67                	jne    80101ea5 <dirlink+0x85>
80101e3e:	8b 7b 5c             	mov    0x5c(%ebx),%edi
80101e41:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e44:	85 ff                	test   %edi,%edi
80101e46:	74 29                	je     80101e71 <dirlink+0x51>
80101e48:	31 ff                	xor    %edi,%edi
80101e4a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e4d:	eb 09                	jmp    80101e58 <dirlink+0x38>
80101e4f:	90                   	nop
80101e50:	83 c7 10             	add    $0x10,%edi
80101e53:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
80101e56:	73 19                	jae    80101e71 <dirlink+0x51>
80101e58:	6a 10                	push   $0x10
80101e5a:	57                   	push   %edi
80101e5b:	56                   	push   %esi
80101e5c:	53                   	push   %ebx
80101e5d:	e8 fe fa ff ff       	call   80101960 <readi>
80101e62:	83 c4 10             	add    $0x10,%esp
80101e65:	83 f8 10             	cmp    $0x10,%eax
80101e68:	75 4e                	jne    80101eb8 <dirlink+0x98>
80101e6a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e6f:	75 df                	jne    80101e50 <dirlink+0x30>
80101e71:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e74:	83 ec 04             	sub    $0x4,%esp
80101e77:	6a 0e                	push   $0xe
80101e79:	ff 75 0c             	pushl  0xc(%ebp)
80101e7c:	50                   	push   %eax
80101e7d:	e8 ee 29 00 00       	call   80104870 <strncpy>
80101e82:	8b 45 10             	mov    0x10(%ebp),%eax
80101e85:	6a 10                	push   $0x10
80101e87:	57                   	push   %edi
80101e88:	56                   	push   %esi
80101e89:	53                   	push   %ebx
80101e8a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
80101e8e:	e8 cd fb ff ff       	call   80101a60 <writei>
80101e93:	83 c4 20             	add    $0x20,%esp
80101e96:	83 f8 10             	cmp    $0x10,%eax
80101e99:	75 2a                	jne    80101ec5 <dirlink+0xa5>
80101e9b:	31 c0                	xor    %eax,%eax
80101e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea0:	5b                   	pop    %ebx
80101ea1:	5e                   	pop    %esi
80101ea2:	5f                   	pop    %edi
80101ea3:	5d                   	pop    %ebp
80101ea4:	c3                   	ret    
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	50                   	push   %eax
80101ea9:	e8 02 f9 ff ff       	call   801017b0 <iput>
80101eae:	83 c4 10             	add    $0x10,%esp
80101eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101eb6:	eb e5                	jmp    80101e9d <dirlink+0x7d>
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	68 28 73 10 80       	push   $0x80107328
80101ec0:	e8 cb e4 ff ff       	call   80100390 <panic>
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	68 6a 7a 10 80       	push   $0x80107a6a
80101ecd:	e8 be e4 ff ff       	call   80100390 <panic>
80101ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <namei>:
80101ee0:	55                   	push   %ebp
80101ee1:	31 d2                	xor    %edx,%edx
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	83 ec 18             	sub    $0x18,%esp
80101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eeb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eee:	e8 6d fd ff ff       	call   80101c60 <namex>
80101ef3:	c9                   	leave  
80101ef4:	c3                   	ret    
80101ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f00 <nameiparent>:
80101f00:	55                   	push   %ebp
80101f01:	ba 01 00 00 00       	mov    $0x1,%edx
80101f06:	89 e5                	mov    %esp,%ebp
80101f08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0e:	5d                   	pop    %ebp
80101f0f:	e9 4c fd ff ff       	jmp    80101c60 <namex>
80101f14:	66 90                	xchg   %ax,%ax
80101f16:	66 90                	xchg   %ax,%ax
80101f18:	66 90                	xchg   %ax,%ax
80101f1a:	66 90                	xchg   %ax,%ax
80101f1c:	66 90                	xchg   %ax,%ax
80101f1e:	66 90                	xchg   %ax,%ax

80101f20 <idestart>:
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	57                   	push   %edi
80101f24:	56                   	push   %esi
80101f25:	53                   	push   %ebx
80101f26:	83 ec 0c             	sub    $0xc,%esp
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	0f 84 b4 00 00 00    	je     80101fe5 <idestart+0xc5>
80101f31:	8b 58 08             	mov    0x8(%eax),%ebx
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f3c:	0f 87 96 00 00 00    	ja     80101fd8 <idestart+0xb8>
80101f42:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f50:	89 ca                	mov    %ecx,%edx
80101f52:	ec                   	in     (%dx),%al
80101f53:	83 e0 c0             	and    $0xffffffc0,%eax
80101f56:	3c 40                	cmp    $0x40,%al
80101f58:	75 f6                	jne    80101f50 <idestart+0x30>
80101f5a:	31 ff                	xor    %edi,%edi
80101f5c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f61:	89 f8                	mov    %edi,%eax
80101f63:	ee                   	out    %al,(%dx)
80101f64:	b8 01 00 00 00       	mov    $0x1,%eax
80101f69:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6e:	ee                   	out    %al,(%dx)
80101f6f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f74:	89 d8                	mov    %ebx,%eax
80101f76:	ee                   	out    %al,(%dx)
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f7e:	c1 f8 08             	sar    $0x8,%eax
80101f81:	ee                   	out    %al,(%dx)
80101f82:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f87:	89 f8                	mov    %edi,%eax
80101f89:	ee                   	out    %al,(%dx)
80101f8a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f93:	c1 e0 04             	shl    $0x4,%eax
80101f96:	83 e0 10             	and    $0x10,%eax
80101f99:	83 c8 e0             	or     $0xffffffe0,%eax
80101f9c:	ee                   	out    %al,(%dx)
80101f9d:	f6 06 04             	testb  $0x4,(%esi)
80101fa0:	75 16                	jne    80101fb8 <idestart+0x98>
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	89 ca                	mov    %ecx,%edx
80101fa9:	ee                   	out    %al,(%dx)
80101faa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fad:	5b                   	pop    %ebx
80101fae:	5e                   	pop    %esi
80101faf:	5f                   	pop    %edi
80101fb0:	5d                   	pop    %ebp
80101fb1:	c3                   	ret    
80101fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fb8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fbd:	89 ca                	mov    %ecx,%edx
80101fbf:	ee                   	out    %al,(%dx)
80101fc0:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fc5:	83 c6 60             	add    $0x60,%esi
80101fc8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fcd:	fc                   	cld    
80101fce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret    
80101fd8:	83 ec 0c             	sub    $0xc,%esp
80101fdb:	68 94 73 10 80       	push   $0x80107394
80101fe0:	e8 ab e3 ff ff       	call   80100390 <panic>
80101fe5:	83 ec 0c             	sub    $0xc,%esp
80101fe8:	68 8b 73 10 80       	push   $0x8010738b
80101fed:	e8 9e e3 ff ff       	call   80100390 <panic>
80101ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 10             	sub    $0x10,%esp
80102006:	68 a6 73 10 80       	push   $0x801073a6
8010200b:	68 80 a5 10 80       	push   $0x8010a580
80102010:	e8 5b 24 00 00       	call   80104470 <initlock>
80102015:	58                   	pop    %eax
80102016:	a1 a0 2e 11 80       	mov    0x80112ea0,%eax
8010201b:	5a                   	pop    %edx
8010201c:	83 e8 01             	sub    $0x1,%eax
8010201f:	50                   	push   %eax
80102020:	6a 0e                	push   $0xe
80102022:	e8 a9 02 00 00       	call   801022d0 <ioapicenable>
80102027:	83 c4 10             	add    $0x10,%esp
8010202a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010202f:	90                   	nop
80102030:	ec                   	in     (%dx),%al
80102031:	83 e0 c0             	and    $0xffffffc0,%eax
80102034:	3c 40                	cmp    $0x40,%al
80102036:	75 f8                	jne    80102030 <ideinit+0x30>
80102038:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102042:	ee                   	out    %al,(%dx)
80102043:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102048:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204d:	eb 06                	jmp    80102055 <ideinit+0x55>
8010204f:	90                   	nop
80102050:	83 e9 01             	sub    $0x1,%ecx
80102053:	74 0f                	je     80102064 <ideinit+0x64>
80102055:	ec                   	in     (%dx),%al
80102056:	84 c0                	test   %al,%al
80102058:	74 f6                	je     80102050 <ideinit+0x50>
8010205a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102061:	00 00 00 
80102064:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102069:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010206e:	ee                   	out    %al,(%dx)
8010206f:	c9                   	leave  
80102070:	c3                   	ret    
80102071:	eb 0d                	jmp    80102080 <ideintr>
80102073:	90                   	nop
80102074:	90                   	nop
80102075:	90                   	nop
80102076:	90                   	nop
80102077:	90                   	nop
80102078:	90                   	nop
80102079:	90                   	nop
8010207a:	90                   	nop
8010207b:	90                   	nop
8010207c:	90                   	nop
8010207d:	90                   	nop
8010207e:	90                   	nop
8010207f:	90                   	nop

80102080 <ideintr>:
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 18             	sub    $0x18,%esp
80102089:	68 80 a5 10 80       	push   $0x8010a580
8010208e:	e8 3d 25 00 00       	call   801045d0 <acquire>
80102093:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102099:	83 c4 10             	add    $0x10,%esp
8010209c:	85 db                	test   %ebx,%ebx
8010209e:	74 67                	je     80102107 <ideintr+0x87>
801020a0:	8b 43 5c             	mov    0x5c(%ebx),%eax
801020a3:	a3 64 a5 10 80       	mov    %eax,0x8010a564
801020a8:	8b 3b                	mov    (%ebx),%edi
801020aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020b0:	75 31                	jne    801020e3 <ideintr+0x63>
801020b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020c0:	ec                   	in     (%dx),%al
801020c1:	89 c6                	mov    %eax,%esi
801020c3:	83 e6 c0             	and    $0xffffffc0,%esi
801020c6:	89 f1                	mov    %esi,%ecx
801020c8:	80 f9 40             	cmp    $0x40,%cl
801020cb:	75 f3                	jne    801020c0 <ideintr+0x40>
801020cd:	a8 21                	test   $0x21,%al
801020cf:	75 12                	jne    801020e3 <ideintr+0x63>
801020d1:	8d 7b 60             	lea    0x60(%ebx),%edi
801020d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020de:	fc                   	cld    
801020df:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e1:	8b 3b                	mov    (%ebx),%edi
801020e3:	83 e7 fb             	and    $0xfffffffb,%edi
801020e6:	83 ec 0c             	sub    $0xc,%esp
801020e9:	89 f9                	mov    %edi,%ecx
801020eb:	83 c9 02             	or     $0x2,%ecx
801020ee:	89 0b                	mov    %ecx,(%ebx)
801020f0:	53                   	push   %ebx
801020f1:	e8 3a 1e 00 00       	call   80103f30 <wakeup>
801020f6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 05                	je     80102107 <ideintr+0x87>
80102102:	e8 19 fe ff ff       	call   80101f20 <idestart>
80102107:	83 ec 0c             	sub    $0xc,%esp
8010210a:	68 80 a5 10 80       	push   $0x8010a580
8010210f:	e8 8c 25 00 00       	call   801046a0 <release>
80102114:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5f                   	pop    %edi
8010211a:	5d                   	pop    %ebp
8010211b:	c3                   	ret    
8010211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102120 <iderw>:
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	50                   	push   %eax
8010212e:	e8 ed 22 00 00       	call   80104420 <holdingsleep>
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	85 c0                	test   %eax,%eax
80102138:	0f 84 c6 00 00 00    	je     80102204 <iderw+0xe4>
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	0f 84 ab 00 00 00    	je     801021f7 <iderw+0xd7>
8010214c:	8b 53 04             	mov    0x4(%ebx),%edx
8010214f:	85 d2                	test   %edx,%edx
80102151:	74 0d                	je     80102160 <iderw+0x40>
80102153:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102158:	85 c0                	test   %eax,%eax
8010215a:	0f 84 b1 00 00 00    	je     80102211 <iderw+0xf1>
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	68 80 a5 10 80       	push   $0x8010a580
80102168:	e8 63 24 00 00       	call   801045d0 <acquire>
8010216d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102173:	83 c4 10             	add    $0x10,%esp
80102176:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010217d:	85 d2                	test   %edx,%edx
8010217f:	75 09                	jne    8010218a <iderw+0x6a>
80102181:	eb 6d                	jmp    801021f0 <iderw+0xd0>
80102183:	90                   	nop
80102184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102188:	89 c2                	mov    %eax,%edx
8010218a:	8b 42 5c             	mov    0x5c(%edx),%eax
8010218d:	85 c0                	test   %eax,%eax
8010218f:	75 f7                	jne    80102188 <iderw+0x68>
80102191:	83 c2 5c             	add    $0x5c,%edx
80102194:	89 1a                	mov    %ebx,(%edx)
80102196:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010219c:	74 42                	je     801021e0 <iderw+0xc0>
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	74 23                	je     801021cb <iderw+0xab>
801021a8:	90                   	nop
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b0:	83 ec 08             	sub    $0x8,%esp
801021b3:	68 80 a5 10 80       	push   $0x8010a580
801021b8:	53                   	push   %ebx
801021b9:	e8 c2 1b 00 00       	call   80103d80 <sleep>
801021be:	8b 03                	mov    (%ebx),%eax
801021c0:	83 c4 10             	add    $0x10,%esp
801021c3:	83 e0 06             	and    $0x6,%eax
801021c6:	83 f8 02             	cmp    $0x2,%eax
801021c9:	75 e5                	jne    801021b0 <iderw+0x90>
801021cb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
801021d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021d5:	c9                   	leave  
801021d6:	e9 c5 24 00 00       	jmp    801046a0 <release>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021e0:	89 d8                	mov    %ebx,%eax
801021e2:	e8 39 fd ff ff       	call   80101f20 <idestart>
801021e7:	eb b5                	jmp    8010219e <iderw+0x7e>
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021f0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801021f5:	eb 9d                	jmp    80102194 <iderw+0x74>
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 c0 73 10 80       	push   $0x801073c0
801021ff:	e8 8c e1 ff ff       	call   80100390 <panic>
80102204:	83 ec 0c             	sub    $0xc,%esp
80102207:	68 aa 73 10 80       	push   $0x801073aa
8010220c:	e8 7f e1 ff ff       	call   80100390 <panic>
80102211:	83 ec 0c             	sub    $0xc,%esp
80102214:	68 d5 73 10 80       	push   $0x801073d5
80102219:	e8 72 e1 ff ff       	call   80100390 <panic>
8010221e:	66 90                	xchg   %ax,%ax

80102220 <ioapicinit>:
80102220:	55                   	push   %ebp
80102221:	c7 05 a0 27 11 80 00 	movl   $0xfec00000,0x801127a0
80102228:	00 c0 fe 
8010222b:	89 e5                	mov    %esp,%ebp
8010222d:	56                   	push   %esi
8010222e:	53                   	push   %ebx
8010222f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102236:	00 00 00 
80102239:	a1 a0 27 11 80       	mov    0x801127a0,%eax
8010223e:	8b 58 10             	mov    0x10(%eax),%ebx
80102241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80102247:	8b 0d a0 27 11 80    	mov    0x801127a0,%ecx
8010224d:	0f b6 15 00 29 11 80 	movzbl 0x80112900,%edx
80102254:	c1 eb 10             	shr    $0x10,%ebx
80102257:	8b 41 10             	mov    0x10(%ecx),%eax
8010225a:	0f b6 db             	movzbl %bl,%ebx
8010225d:	c1 e8 18             	shr    $0x18,%eax
80102260:	39 c2                	cmp    %eax,%edx
80102262:	74 16                	je     8010227a <ioapicinit+0x5a>
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 f4 73 10 80       	push   $0x801073f4
8010226c:	e8 ef e3 ff ff       	call   80100660 <cprintf>
80102271:	8b 0d a0 27 11 80    	mov    0x801127a0,%ecx
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	83 c3 21             	add    $0x21,%ebx
8010227d:	ba 10 00 00 00       	mov    $0x10,%edx
80102282:	b8 20 00 00 00       	mov    $0x20,%eax
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102290:	89 11                	mov    %edx,(%ecx)
80102292:	8b 0d a0 27 11 80    	mov    0x801127a0,%ecx
80102298:	89 c6                	mov    %eax,%esi
8010229a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022a0:	83 c0 01             	add    $0x1,%eax
801022a3:	89 71 10             	mov    %esi,0x10(%ecx)
801022a6:	8d 72 01             	lea    0x1(%edx),%esi
801022a9:	83 c2 02             	add    $0x2,%edx
801022ac:	39 d8                	cmp    %ebx,%eax
801022ae:	89 31                	mov    %esi,(%ecx)
801022b0:	8b 0d a0 27 11 80    	mov    0x801127a0,%ecx
801022b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
801022bd:	75 d1                	jne    80102290 <ioapicinit+0x70>
801022bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022c2:	5b                   	pop    %ebx
801022c3:	5e                   	pop    %esi
801022c4:	5d                   	pop    %ebp
801022c5:	c3                   	ret    
801022c6:	8d 76 00             	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <ioapicenable>:
801022d0:	55                   	push   %ebp
801022d1:	8b 0d a0 27 11 80    	mov    0x801127a0,%ecx
801022d7:	89 e5                	mov    %esp,%ebp
801022d9:	8b 45 08             	mov    0x8(%ebp),%eax
801022dc:	8d 50 20             	lea    0x20(%eax),%edx
801022df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
801022e3:	89 01                	mov    %eax,(%ecx)
801022e5:	8b 0d a0 27 11 80    	mov    0x801127a0,%ecx
801022eb:	83 c0 01             	add    $0x1,%eax
801022ee:	89 51 10             	mov    %edx,0x10(%ecx)
801022f1:	8b 55 0c             	mov    0xc(%ebp),%edx
801022f4:	89 01                	mov    %eax,(%ecx)
801022f6:	a1 a0 27 11 80       	mov    0x801127a0,%eax
801022fb:	c1 e2 18             	shl    $0x18,%edx
801022fe:	89 50 10             	mov    %edx,0x10(%eax)
80102301:	5d                   	pop    %ebp
80102302:	c3                   	ret    
80102303:	66 90                	xchg   %ax,%ax
80102305:	66 90                	xchg   %ax,%ax
80102307:	66 90                	xchg   %ax,%ax
80102309:	66 90                	xchg   %ax,%ax
8010230b:	66 90                	xchg   %ax,%ax
8010230d:	66 90                	xchg   %ax,%ax
8010230f:	90                   	nop

80102310 <kfree>:
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	53                   	push   %ebx
80102314:	83 ec 04             	sub    $0x4,%esp
80102317:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010231a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102320:	75 70                	jne    80102392 <kfree+0x82>
80102322:	81 fb c8 56 11 80    	cmp    $0x801156c8,%ebx
80102328:	72 68                	jb     80102392 <kfree+0x82>
8010232a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102330:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102335:	77 5b                	ja     80102392 <kfree+0x82>
80102337:	83 ec 04             	sub    $0x4,%esp
8010233a:	68 00 10 00 00       	push   $0x1000
8010233f:	6a 01                	push   $0x1
80102341:	53                   	push   %ebx
80102342:	e8 a9 23 00 00       	call   801046f0 <memset>
80102347:	8b 15 f8 27 11 80    	mov    0x801127f8,%edx
8010234d:	83 c4 10             	add    $0x10,%esp
80102350:	85 d2                	test   %edx,%edx
80102352:	75 2c                	jne    80102380 <kfree+0x70>
80102354:	a1 fc 27 11 80       	mov    0x801127fc,%eax
80102359:	89 03                	mov    %eax,(%ebx)
8010235b:	a1 f8 27 11 80       	mov    0x801127f8,%eax
80102360:	89 1d fc 27 11 80    	mov    %ebx,0x801127fc
80102366:	85 c0                	test   %eax,%eax
80102368:	75 06                	jne    80102370 <kfree+0x60>
8010236a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010236d:	c9                   	leave  
8010236e:	c3                   	ret    
8010236f:	90                   	nop
80102370:	c7 45 08 c0 27 11 80 	movl   $0x801127c0,0x8(%ebp)
80102377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237a:	c9                   	leave  
8010237b:	e9 20 23 00 00       	jmp    801046a0 <release>
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 c0 27 11 80       	push   $0x801127c0
80102388:	e8 43 22 00 00       	call   801045d0 <acquire>
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	eb c2                	jmp    80102354 <kfree+0x44>
80102392:	83 ec 0c             	sub    $0xc,%esp
80102395:	68 26 74 10 80       	push   $0x80107426
8010239a:	e8 f1 df ff ff       	call   80100390 <panic>
8010239f:	90                   	nop

801023a0 <freerange>:
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	8b 45 08             	mov    0x8(%ebp),%eax
801023a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801023ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801023b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bd:	39 de                	cmp    %ebx,%esi
801023bf:	72 23                	jb     801023e4 <freerange+0x44>
801023c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023ce:	83 ec 0c             	sub    $0xc,%esp
801023d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023d7:	50                   	push   %eax
801023d8:	e8 33 ff ff ff       	call   80102310 <kfree>
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	39 f3                	cmp    %esi,%ebx
801023e2:	76 e4                	jbe    801023c8 <freerange+0x28>
801023e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e7:	5b                   	pop    %ebx
801023e8:	5e                   	pop    %esi
801023e9:	5d                   	pop    %ebp
801023ea:	c3                   	ret    
801023eb:	90                   	nop
801023ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023f0 <kinit1>:
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	8b 75 0c             	mov    0xc(%ebp),%esi
801023f8:	83 ec 08             	sub    $0x8,%esp
801023fb:	68 2c 74 10 80       	push   $0x8010742c
80102400:	68 c0 27 11 80       	push   $0x801127c0
80102405:	e8 66 20 00 00       	call   80104470 <initlock>
8010240a:	8b 45 08             	mov    0x8(%ebp),%eax
8010240d:	83 c4 10             	add    $0x10,%esp
80102410:	c7 05 f8 27 11 80 00 	movl   $0x0,0x801127f8
80102417:	00 00 00 
8010241a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102420:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102426:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242c:	39 de                	cmp    %ebx,%esi
8010242e:	72 1c                	jb     8010244c <kinit1+0x5c>
80102430:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102436:	83 ec 0c             	sub    $0xc,%esp
80102439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243f:	50                   	push   %eax
80102440:	e8 cb fe ff ff       	call   80102310 <kfree>
80102445:	83 c4 10             	add    $0x10,%esp
80102448:	39 de                	cmp    %ebx,%esi
8010244a:	73 e4                	jae    80102430 <kinit1+0x40>
8010244c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010244f:	5b                   	pop    %ebx
80102450:	5e                   	pop    %esi
80102451:	5d                   	pop    %ebp
80102452:	c3                   	ret    
80102453:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <kinit2+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102497:	50                   	push   %eax
80102498:	e8 73 fe ff ff       	call   80102310 <kfree>
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 e4                	jae    80102488 <kinit2+0x28>
801024a4:	c7 05 f8 27 11 80 01 	movl   $0x1,0x801127f8
801024ab:	00 00 00 
801024ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5d                   	pop    %ebp
801024b4:	c3                   	ret    
801024b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kalloc>:
801024c0:	a1 f8 27 11 80       	mov    0x801127f8,%eax
801024c5:	85 c0                	test   %eax,%eax
801024c7:	75 1f                	jne    801024e8 <kalloc+0x28>
801024c9:	a1 fc 27 11 80       	mov    0x801127fc,%eax
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 0e                	je     801024e0 <kalloc+0x20>
801024d2:	8b 10                	mov    (%eax),%edx
801024d4:	89 15 fc 27 11 80    	mov    %edx,0x801127fc
801024da:	c3                   	ret    
801024db:	90                   	nop
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e0:	f3 c3                	repz ret 
801024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024e8:	55                   	push   %ebp
801024e9:	89 e5                	mov    %esp,%ebp
801024eb:	83 ec 24             	sub    $0x24,%esp
801024ee:	68 c0 27 11 80       	push   $0x801127c0
801024f3:	e8 d8 20 00 00       	call   801045d0 <acquire>
801024f8:	a1 fc 27 11 80       	mov    0x801127fc,%eax
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	8b 15 f8 27 11 80    	mov    0x801127f8,%edx
80102506:	85 c0                	test   %eax,%eax
80102508:	74 08                	je     80102512 <kalloc+0x52>
8010250a:	8b 08                	mov    (%eax),%ecx
8010250c:	89 0d fc 27 11 80    	mov    %ecx,0x801127fc
80102512:	85 d2                	test   %edx,%edx
80102514:	74 16                	je     8010252c <kalloc+0x6c>
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010251c:	68 c0 27 11 80       	push   $0x801127c0
80102521:	e8 7a 21 00 00       	call   801046a0 <release>
80102526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102529:	83 c4 10             	add    $0x10,%esp
8010252c:	c9                   	leave  
8010252d:	c3                   	ret    
8010252e:	66 90                	xchg   %ax,%ax

80102530 <kbdgetc>:
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 c2 00 00 00    	je     80102600 <kbdgetc+0xd0>
8010253e:	ba 60 00 00 00       	mov    $0x60,%edx
80102543:	ec                   	in     (%dx),%al
80102544:	0f b6 d0             	movzbl %al,%edx
80102547:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
8010254d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102553:	0f 84 7f 00 00 00    	je     801025d8 <kbdgetc+0xa8>
80102559:	55                   	push   %ebp
8010255a:	89 e5                	mov    %esp,%ebp
8010255c:	53                   	push   %ebx
8010255d:	89 cb                	mov    %ecx,%ebx
8010255f:	83 e3 40             	and    $0x40,%ebx
80102562:	84 c0                	test   %al,%al
80102564:	78 4a                	js     801025b0 <kbdgetc+0x80>
80102566:	85 db                	test   %ebx,%ebx
80102568:	74 09                	je     80102573 <kbdgetc+0x43>
8010256a:	83 c8 80             	or     $0xffffff80,%eax
8010256d:	83 e1 bf             	and    $0xffffffbf,%ecx
80102570:	0f b6 d0             	movzbl %al,%edx
80102573:	0f b6 82 60 75 10 80 	movzbl -0x7fef8aa0(%edx),%eax
8010257a:	09 c1                	or     %eax,%ecx
8010257c:	0f b6 82 60 74 10 80 	movzbl -0x7fef8ba0(%edx),%eax
80102583:	31 c1                	xor    %eax,%ecx
80102585:	89 c8                	mov    %ecx,%eax
80102587:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
8010258d:	83 e0 03             	and    $0x3,%eax
80102590:	83 e1 08             	and    $0x8,%ecx
80102593:	8b 04 85 40 74 10 80 	mov    -0x7fef8bc0(,%eax,4),%eax
8010259a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
8010259e:	74 31                	je     801025d1 <kbdgetc+0xa1>
801025a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a3:	83 fa 19             	cmp    $0x19,%edx
801025a6:	77 40                	ja     801025e8 <kbdgetc+0xb8>
801025a8:	83 e8 20             	sub    $0x20,%eax
801025ab:	5b                   	pop    %ebx
801025ac:	5d                   	pop    %ebp
801025ad:	c3                   	ret    
801025ae:	66 90                	xchg   %ax,%ax
801025b0:	83 e0 7f             	and    $0x7f,%eax
801025b3:	85 db                	test   %ebx,%ebx
801025b5:	0f 44 d0             	cmove  %eax,%edx
801025b8:	0f b6 82 60 75 10 80 	movzbl -0x7fef8aa0(%edx),%eax
801025bf:	83 c8 40             	or     $0x40,%eax
801025c2:	0f b6 c0             	movzbl %al,%eax
801025c5:	f7 d0                	not    %eax
801025c7:	21 c1                	and    %eax,%ecx
801025c9:	31 c0                	xor    %eax,%eax
801025cb:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
801025d1:	5b                   	pop    %ebx
801025d2:	5d                   	pop    %ebp
801025d3:	c3                   	ret    
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025d8:	83 c9 40             	or     $0x40,%ecx
801025db:	31 c0                	xor    %eax,%eax
801025dd:	89 0d b8 a5 10 80    	mov    %ecx,0x8010a5b8
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
801025ee:	5b                   	pop    %ebx
801025ef:	83 f9 1a             	cmp    $0x1a,%ecx
801025f2:	0f 42 c2             	cmovb  %edx,%eax
801025f5:	5d                   	pop    %ebp
801025f6:	c3                   	ret    
801025f7:	89 f6                	mov    %esi,%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102605:	c3                   	ret    
80102606:	8d 76 00             	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kbdintr>:
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
80102616:	68 30 25 10 80       	push   $0x80102530
8010261b:	e8 f0 e1 ff ff       	call   80100810 <consoleintr>
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	c9                   	leave  
80102624:	c3                   	ret    
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <lapicinit>:
80102630:	a1 00 28 11 80       	mov    0x80112800,%eax
80102635:	55                   	push   %ebp
80102636:	89 e5                	mov    %esp,%ebp
80102638:	85 c0                	test   %eax,%eax
8010263a:	0f 84 c8 00 00 00    	je     80102708 <lapicinit+0xd8>
80102640:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102647:	01 00 00 
8010264a:	8b 50 20             	mov    0x20(%eax),%edx
8010264d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102654:	00 00 00 
80102657:	8b 50 20             	mov    0x20(%eax),%edx
8010265a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102661:	00 02 00 
80102664:	8b 50 20             	mov    0x20(%eax),%edx
80102667:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010266e:	96 98 00 
80102671:	8b 50 20             	mov    0x20(%eax),%edx
80102674:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010267b:	00 01 00 
8010267e:	8b 50 20             	mov    0x20(%eax),%edx
80102681:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102688:	00 01 00 
8010268b:	8b 50 20             	mov    0x20(%eax),%edx
8010268e:	8b 50 30             	mov    0x30(%eax),%edx
80102691:	c1 ea 10             	shr    $0x10,%edx
80102694:	80 fa 03             	cmp    $0x3,%dl
80102697:	77 77                	ja     80102710 <lapicinit+0xe0>
80102699:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026a0:	00 00 00 
801026a3:	8b 50 20             	mov    0x20(%eax),%edx
801026a6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ad:	00 00 00 
801026b0:	8b 50 20             	mov    0x20(%eax),%edx
801026b3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ba:	00 00 00 
801026bd:	8b 50 20             	mov    0x20(%eax),%edx
801026c0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026c7:	00 00 00 
801026ca:	8b 50 20             	mov    0x20(%eax),%edx
801026cd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026d4:	00 00 00 
801026d7:	8b 50 20             	mov    0x20(%eax),%edx
801026da:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026e1:	85 08 00 
801026e4:	8b 50 20             	mov    0x20(%eax),%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801026f0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026f6:	80 e6 10             	and    $0x10,%dh
801026f9:	75 f5                	jne    801026f0 <lapicinit+0xc0>
801026fb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102702:	00 00 00 
80102705:	8b 40 20             	mov    0x20(%eax),%eax
80102708:	5d                   	pop    %ebp
80102709:	c3                   	ret    
8010270a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102710:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102717:	00 01 00 
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
8010271d:	e9 77 ff ff ff       	jmp    80102699 <lapicinit+0x69>
80102722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <lapicid>:
80102730:	8b 15 00 28 11 80    	mov    0x80112800,%edx
80102736:	55                   	push   %ebp
80102737:	31 c0                	xor    %eax,%eax
80102739:	89 e5                	mov    %esp,%ebp
8010273b:	85 d2                	test   %edx,%edx
8010273d:	74 06                	je     80102745 <lapicid+0x15>
8010273f:	8b 42 20             	mov    0x20(%edx),%eax
80102742:	c1 e8 18             	shr    $0x18,%eax
80102745:	5d                   	pop    %ebp
80102746:	c3                   	ret    
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapiceoi>:
80102750:	a1 00 28 11 80       	mov    0x80112800,%eax
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0d                	je     80102769 <lapiceoi+0x19>
8010275c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102763:	00 00 00 
80102766:	8b 40 20             	mov    0x20(%eax),%eax
80102769:	5d                   	pop    %ebp
8010276a:	c3                   	ret    
8010276b:	90                   	nop
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <microdelay>:
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	5d                   	pop    %ebp
80102774:	c3                   	ret    
80102775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102780 <lapicstartap>:
80102780:	55                   	push   %ebp
80102781:	b8 0f 00 00 00       	mov    $0xf,%eax
80102786:	ba 70 00 00 00       	mov    $0x70,%edx
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102794:	ee                   	out    %al,(%dx)
80102795:	b8 0a 00 00 00       	mov    $0xa,%eax
8010279a:	ba 71 00 00 00       	mov    $0x71,%edx
8010279f:	ee                   	out    %al,(%dx)
801027a0:	31 c0                	xor    %eax,%eax
801027a2:	c1 e3 18             	shl    $0x18,%ebx
801027a5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
801027ab:	89 c8                	mov    %ecx,%eax
801027ad:	c1 e9 0c             	shr    $0xc,%ecx
801027b0:	c1 e8 04             	shr    $0x4,%eax
801027b3:	89 da                	mov    %ebx,%edx
801027b5:	80 cd 06             	or     $0x6,%ch
801027b8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
801027be:	a1 00 28 11 80       	mov    0x80112800,%eax
801027c3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
801027c9:	8b 58 20             	mov    0x20(%eax),%ebx
801027cc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027d3:	c5 00 00 
801027d6:	8b 58 20             	mov    0x20(%eax),%ebx
801027d9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027e0:	85 00 00 
801027e3:	8b 58 20             	mov    0x20(%eax),%ebx
801027e6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
801027ec:	8b 58 20             	mov    0x20(%eax),%ebx
801027ef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
801027f5:	8b 58 20             	mov    0x20(%eax),%ebx
801027f8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
80102801:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
80102807:	8b 40 20             	mov    0x20(%eax),%eax
8010280a:	5b                   	pop    %ebx
8010280b:	5d                   	pop    %ebp
8010280c:	c3                   	ret    
8010280d:	8d 76 00             	lea    0x0(%esi),%esi

80102810 <cmostime>:
80102810:	55                   	push   %ebp
80102811:	b8 0b 00 00 00       	mov    $0xb,%eax
80102816:	ba 70 00 00 00       	mov    $0x70,%edx
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	57                   	push   %edi
8010281e:	56                   	push   %esi
8010281f:	53                   	push   %ebx
80102820:	83 ec 4c             	sub    $0x4c,%esp
80102823:	ee                   	out    %al,(%dx)
80102824:	ba 71 00 00 00       	mov    $0x71,%edx
80102829:	ec                   	in     (%dx),%al
8010282a:	83 e0 04             	and    $0x4,%eax
8010282d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102832:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102835:	8d 76 00             	lea    0x0(%esi),%esi
80102838:	31 c0                	xor    %eax,%eax
8010283a:	89 da                	mov    %ebx,%edx
8010283c:	ee                   	out    %al,(%dx)
8010283d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102842:	89 ca                	mov    %ecx,%edx
80102844:	ec                   	in     (%dx),%al
80102845:	88 45 b7             	mov    %al,-0x49(%ebp)
80102848:	89 da                	mov    %ebx,%edx
8010284a:	b8 02 00 00 00       	mov    $0x2,%eax
8010284f:	ee                   	out    %al,(%dx)
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
80102853:	88 45 b6             	mov    %al,-0x4a(%ebp)
80102856:	89 da                	mov    %ebx,%edx
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
80102861:	88 45 b5             	mov    %al,-0x4b(%ebp)
80102864:	89 da                	mov    %ebx,%edx
80102866:	b8 07 00 00 00       	mov    $0x7,%eax
8010286b:	ee                   	out    %al,(%dx)
8010286c:	89 ca                	mov    %ecx,%edx
8010286e:	ec                   	in     (%dx),%al
8010286f:	88 45 b4             	mov    %al,-0x4c(%ebp)
80102872:	89 da                	mov    %ebx,%edx
80102874:	b8 08 00 00 00       	mov    $0x8,%eax
80102879:	ee                   	out    %al,(%dx)
8010287a:	89 ca                	mov    %ecx,%edx
8010287c:	ec                   	in     (%dx),%al
8010287d:	89 c7                	mov    %eax,%edi
8010287f:	89 da                	mov    %ebx,%edx
80102881:	b8 09 00 00 00       	mov    $0x9,%eax
80102886:	ee                   	out    %al,(%dx)
80102887:	89 ca                	mov    %ecx,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	89 c6                	mov    %eax,%esi
8010288c:	89 da                	mov    %ebx,%edx
8010288e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102893:	ee                   	out    %al,(%dx)
80102894:	89 ca                	mov    %ecx,%edx
80102896:	ec                   	in     (%dx),%al
80102897:	84 c0                	test   %al,%al
80102899:	78 9d                	js     80102838 <cmostime+0x28>
8010289b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010289f:	89 fa                	mov    %edi,%edx
801028a1:	0f b6 fa             	movzbl %dl,%edi
801028a4:	89 f2                	mov    %esi,%edx
801028a6:	0f b6 f2             	movzbl %dl,%esi
801028a9:	89 7d c8             	mov    %edi,-0x38(%ebp)
801028ac:	89 da                	mov    %ebx,%edx
801028ae:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028b1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028b4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028b8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028bb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028bf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028c2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028c9:	31 c0                	xor    %eax,%eax
801028cb:	ee                   	out    %al,(%dx)
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	0f b6 c0             	movzbl %al,%eax
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028d7:	b8 02 00 00 00       	mov    $0x2,%eax
801028dc:	ee                   	out    %al,(%dx)
801028dd:	89 ca                	mov    %ecx,%edx
801028df:	ec                   	in     (%dx),%al
801028e0:	0f b6 c0             	movzbl %al,%eax
801028e3:	89 da                	mov    %ebx,%edx
801028e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028e8:	b8 04 00 00 00       	mov    $0x4,%eax
801028ed:	ee                   	out    %al,(%dx)
801028ee:	89 ca                	mov    %ecx,%edx
801028f0:	ec                   	in     (%dx),%al
801028f1:	0f b6 c0             	movzbl %al,%eax
801028f4:	89 da                	mov    %ebx,%edx
801028f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028f9:	b8 07 00 00 00       	mov    $0x7,%eax
801028fe:	ee                   	out    %al,(%dx)
801028ff:	89 ca                	mov    %ecx,%edx
80102901:	ec                   	in     (%dx),%al
80102902:	0f b6 c0             	movzbl %al,%eax
80102905:	89 da                	mov    %ebx,%edx
80102907:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010290a:	b8 08 00 00 00       	mov    $0x8,%eax
8010290f:	ee                   	out    %al,(%dx)
80102910:	89 ca                	mov    %ecx,%edx
80102912:	ec                   	in     (%dx),%al
80102913:	0f b6 c0             	movzbl %al,%eax
80102916:	89 da                	mov    %ebx,%edx
80102918:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010291b:	b8 09 00 00 00       	mov    $0x9,%eax
80102920:	ee                   	out    %al,(%dx)
80102921:	89 ca                	mov    %ecx,%edx
80102923:	ec                   	in     (%dx),%al
80102924:	0f b6 c0             	movzbl %al,%eax
80102927:	83 ec 04             	sub    $0x4,%esp
8010292a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010292d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102930:	6a 18                	push   $0x18
80102932:	50                   	push   %eax
80102933:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102936:	50                   	push   %eax
80102937:	e8 04 1e 00 00       	call   80104740 <memcmp>
8010293c:	83 c4 10             	add    $0x10,%esp
8010293f:	85 c0                	test   %eax,%eax
80102941:	0f 85 f1 fe ff ff    	jne    80102838 <cmostime+0x28>
80102947:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010294b:	75 78                	jne    801029c5 <cmostime+0x1b5>
8010294d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102950:	89 c2                	mov    %eax,%edx
80102952:	83 e0 0f             	and    $0xf,%eax
80102955:	c1 ea 04             	shr    $0x4,%edx
80102958:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010295b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102961:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102964:	89 c2                	mov    %eax,%edx
80102966:	83 e0 0f             	and    $0xf,%eax
80102969:	c1 ea 04             	shr    $0x4,%edx
8010296c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102972:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102975:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102978:	89 c2                	mov    %eax,%edx
8010297a:	83 e0 0f             	and    $0xf,%eax
8010297d:	c1 ea 04             	shr    $0x4,%edx
80102980:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102983:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102986:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102989:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010298c:	89 c2                	mov    %eax,%edx
8010298e:	83 e0 0f             	and    $0xf,%eax
80102991:	c1 ea 04             	shr    $0x4,%edx
80102994:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102997:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010299d:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029a0:	89 c2                	mov    %eax,%edx
801029a2:	83 e0 0f             	and    $0xf,%eax
801029a5:	c1 ea 04             	shr    $0x4,%edx
801029a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
801029b1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029b4:	89 c2                	mov    %eax,%edx
801029b6:	83 e0 0f             	and    $0xf,%eax
801029b9:	c1 ea 04             	shr    $0x4,%edx
801029bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
801029c5:	8b 75 08             	mov    0x8(%ebp),%esi
801029c8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cb:	89 06                	mov    %eax,(%esi)
801029cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d0:	89 46 04             	mov    %eax,0x4(%esi)
801029d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d6:	89 46 08             	mov    %eax,0x8(%esi)
801029d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029dc:	89 46 0c             	mov    %eax,0xc(%esi)
801029df:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e2:	89 46 10             	mov    %eax,0x10(%esi)
801029e5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029e8:	89 46 14             	mov    %eax,0x14(%esi)
801029eb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
801029f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029f5:	5b                   	pop    %ebx
801029f6:	5e                   	pop    %esi
801029f7:	5f                   	pop    %edi
801029f8:	5d                   	pop    %ebp
801029f9:	c3                   	ret    
801029fa:	66 90                	xchg   %ax,%ax
801029fc:	66 90                	xchg   %ax,%ax
801029fe:	66 90                	xchg   %ax,%ax

80102a00 <install_trans>:
80102a00:	8b 0d 6c 28 11 80    	mov    0x8011286c,%ecx
80102a06:	85 c9                	test   %ecx,%ecx
80102a08:	0f 8e 8a 00 00 00    	jle    80102a98 <install_trans+0x98>
80102a0e:	55                   	push   %ebp
80102a0f:	89 e5                	mov    %esp,%ebp
80102a11:	57                   	push   %edi
80102a12:	56                   	push   %esi
80102a13:	53                   	push   %ebx
80102a14:	31 db                	xor    %ebx,%ebx
80102a16:	83 ec 0c             	sub    $0xc,%esp
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a20:	a1 58 28 11 80       	mov    0x80112858,%eax
80102a25:	83 ec 08             	sub    $0x8,%esp
80102a28:	01 d8                	add    %ebx,%eax
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	50                   	push   %eax
80102a2e:	ff 35 68 28 11 80    	pushl  0x80112868
80102a34:	e8 97 d6 ff ff       	call   801000d0 <bread>
80102a39:	89 c7                	mov    %eax,%edi
80102a3b:	58                   	pop    %eax
80102a3c:	5a                   	pop    %edx
80102a3d:	ff 34 9d 70 28 11 80 	pushl  -0x7feed790(,%ebx,4)
80102a44:	ff 35 68 28 11 80    	pushl  0x80112868
80102a4a:	83 c3 01             	add    $0x1,%ebx
80102a4d:	e8 7e d6 ff ff       	call   801000d0 <bread>
80102a52:	89 c6                	mov    %eax,%esi
80102a54:	8d 47 60             	lea    0x60(%edi),%eax
80102a57:	83 c4 0c             	add    $0xc,%esp
80102a5a:	68 00 02 00 00       	push   $0x200
80102a5f:	50                   	push   %eax
80102a60:	8d 46 60             	lea    0x60(%esi),%eax
80102a63:	50                   	push   %eax
80102a64:	e8 37 1d 00 00       	call   801047a0 <memmove>
80102a69:	89 34 24             	mov    %esi,(%esp)
80102a6c:	e8 2f d7 ff ff       	call   801001a0 <bwrite>
80102a71:	89 3c 24             	mov    %edi,(%esp)
80102a74:	e8 67 d7 ff ff       	call   801001e0 <brelse>
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 5f d7 ff ff       	call   801001e0 <brelse>
80102a81:	83 c4 10             	add    $0x10,%esp
80102a84:	39 1d 6c 28 11 80    	cmp    %ebx,0x8011286c
80102a8a:	7f 94                	jg     80102a20 <install_trans+0x20>
80102a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a8f:	5b                   	pop    %ebx
80102a90:	5e                   	pop    %esi
80102a91:	5f                   	pop    %edi
80102a92:	5d                   	pop    %ebp
80102a93:	c3                   	ret    
80102a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a98:	f3 c3                	repz ret 
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102aa0 <write_head>:
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	ff 35 58 28 11 80    	pushl  0x80112858
80102aae:	ff 35 68 28 11 80    	pushl  0x80112868
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
80102ab9:	8b 1d 6c 28 11 80    	mov    0x8011286c,%ebx
80102abf:	83 c4 10             	add    $0x10,%esp
80102ac2:	89 c6                	mov    %eax,%esi
80102ac4:	85 db                	test   %ebx,%ebx
80102ac6:	89 58 60             	mov    %ebx,0x60(%eax)
80102ac9:	7e 16                	jle    80102ae1 <write_head+0x41>
80102acb:	c1 e3 02             	shl    $0x2,%ebx
80102ace:	31 d2                	xor    %edx,%edx
80102ad0:	8b 8a 70 28 11 80    	mov    -0x7feed790(%edx),%ecx
80102ad6:	89 4c 16 64          	mov    %ecx,0x64(%esi,%edx,1)
80102ada:	83 c2 04             	add    $0x4,%edx
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <write_head+0x30>
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	56                   	push   %esi
80102ae5:	e8 b6 d6 ff ff       	call   801001a0 <bwrite>
80102aea:	89 34 24             	mov    %esi,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
80102af2:	83 c4 10             	add    $0x10,%esp
80102af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102af8:	5b                   	pop    %ebx
80102af9:	5e                   	pop    %esi
80102afa:	5d                   	pop    %ebp
80102afb:	c3                   	ret    
80102afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b00 <initlog>:
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	53                   	push   %ebx
80102b04:	83 ec 2c             	sub    $0x2c,%esp
80102b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b0a:	68 60 76 10 80       	push   $0x80107660
80102b0f:	68 20 28 11 80       	push   $0x80112820
80102b14:	e8 57 19 00 00       	call   80104470 <initlock>
80102b19:	58                   	pop    %eax
80102b1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b1d:	5a                   	pop    %edx
80102b1e:	50                   	push   %eax
80102b1f:	53                   	push   %ebx
80102b20:	e8 1b e9 ff ff       	call   80101440 <readsb>
80102b25:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102b2b:	59                   	pop    %ecx
80102b2c:	89 1d 68 28 11 80    	mov    %ebx,0x80112868
80102b32:	89 15 5c 28 11 80    	mov    %edx,0x8011285c
80102b38:	a3 58 28 11 80       	mov    %eax,0x80112858
80102b3d:	5a                   	pop    %edx
80102b3e:	50                   	push   %eax
80102b3f:	53                   	push   %ebx
80102b40:	e8 8b d5 ff ff       	call   801000d0 <bread>
80102b45:	8b 58 60             	mov    0x60(%eax),%ebx
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 db                	test   %ebx,%ebx
80102b4d:	89 1d 6c 28 11 80    	mov    %ebx,0x8011286c
80102b53:	7e 1c                	jle    80102b71 <initlog+0x71>
80102b55:	c1 e3 02             	shl    $0x2,%ebx
80102b58:	31 d2                	xor    %edx,%edx
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b60:	8b 4c 10 64          	mov    0x64(%eax,%edx,1),%ecx
80102b64:	83 c2 04             	add    $0x4,%edx
80102b67:	89 8a 6c 28 11 80    	mov    %ecx,-0x7feed794(%edx)
80102b6d:	39 d3                	cmp    %edx,%ebx
80102b6f:	75 ef                	jne    80102b60 <initlog+0x60>
80102b71:	83 ec 0c             	sub    $0xc,%esp
80102b74:	50                   	push   %eax
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>
80102b7a:	e8 81 fe ff ff       	call   80102a00 <install_trans>
80102b7f:	c7 05 6c 28 11 80 00 	movl   $0x0,0x8011286c
80102b86:	00 00 00 
80102b89:	e8 12 ff ff ff       	call   80102aa0 <write_head>
80102b8e:	83 c4 10             	add    $0x10,%esp
80102b91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <begin_op>:
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	83 ec 14             	sub    $0x14,%esp
80102ba6:	68 20 28 11 80       	push   $0x80112820
80102bab:	e8 20 1a 00 00       	call   801045d0 <acquire>
80102bb0:	83 c4 10             	add    $0x10,%esp
80102bb3:	eb 18                	jmp    80102bcd <begin_op+0x2d>
80102bb5:	8d 76 00             	lea    0x0(%esi),%esi
80102bb8:	83 ec 08             	sub    $0x8,%esp
80102bbb:	68 20 28 11 80       	push   $0x80112820
80102bc0:	68 20 28 11 80       	push   $0x80112820
80102bc5:	e8 b6 11 00 00       	call   80103d80 <sleep>
80102bca:	83 c4 10             	add    $0x10,%esp
80102bcd:	a1 64 28 11 80       	mov    0x80112864,%eax
80102bd2:	85 c0                	test   %eax,%eax
80102bd4:	75 e2                	jne    80102bb8 <begin_op+0x18>
80102bd6:	a1 60 28 11 80       	mov    0x80112860,%eax
80102bdb:	8b 15 6c 28 11 80    	mov    0x8011286c,%edx
80102be1:	83 c0 01             	add    $0x1,%eax
80102be4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102be7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bea:	83 fa 1e             	cmp    $0x1e,%edx
80102bed:	7f c9                	jg     80102bb8 <begin_op+0x18>
80102bef:	83 ec 0c             	sub    $0xc,%esp
80102bf2:	a3 60 28 11 80       	mov    %eax,0x80112860
80102bf7:	68 20 28 11 80       	push   $0x80112820
80102bfc:	e8 9f 1a 00 00       	call   801046a0 <release>
80102c01:	83 c4 10             	add    $0x10,%esp
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <end_op>:
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	57                   	push   %edi
80102c14:	56                   	push   %esi
80102c15:	53                   	push   %ebx
80102c16:	83 ec 18             	sub    $0x18,%esp
80102c19:	68 20 28 11 80       	push   $0x80112820
80102c1e:	e8 ad 19 00 00       	call   801045d0 <acquire>
80102c23:	a1 60 28 11 80       	mov    0x80112860,%eax
80102c28:	8b 35 64 28 11 80    	mov    0x80112864,%esi
80102c2e:	83 c4 10             	add    $0x10,%esp
80102c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102c34:	85 f6                	test   %esi,%esi
80102c36:	89 1d 60 28 11 80    	mov    %ebx,0x80112860
80102c3c:	0f 85 1a 01 00 00    	jne    80102d5c <end_op+0x14c>
80102c42:	85 db                	test   %ebx,%ebx
80102c44:	0f 85 ee 00 00 00    	jne    80102d38 <end_op+0x128>
80102c4a:	83 ec 0c             	sub    $0xc,%esp
80102c4d:	c7 05 64 28 11 80 01 	movl   $0x1,0x80112864
80102c54:	00 00 00 
80102c57:	68 20 28 11 80       	push   $0x80112820
80102c5c:	e8 3f 1a 00 00       	call   801046a0 <release>
80102c61:	8b 0d 6c 28 11 80    	mov    0x8011286c,%ecx
80102c67:	83 c4 10             	add    $0x10,%esp
80102c6a:	85 c9                	test   %ecx,%ecx
80102c6c:	0f 8e 85 00 00 00    	jle    80102cf7 <end_op+0xe7>
80102c72:	a1 58 28 11 80       	mov    0x80112858,%eax
80102c77:	83 ec 08             	sub    $0x8,%esp
80102c7a:	01 d8                	add    %ebx,%eax
80102c7c:	83 c0 01             	add    $0x1,%eax
80102c7f:	50                   	push   %eax
80102c80:	ff 35 68 28 11 80    	pushl  0x80112868
80102c86:	e8 45 d4 ff ff       	call   801000d0 <bread>
80102c8b:	89 c6                	mov    %eax,%esi
80102c8d:	58                   	pop    %eax
80102c8e:	5a                   	pop    %edx
80102c8f:	ff 34 9d 70 28 11 80 	pushl  -0x7feed790(,%ebx,4)
80102c96:	ff 35 68 28 11 80    	pushl  0x80112868
80102c9c:	83 c3 01             	add    $0x1,%ebx
80102c9f:	e8 2c d4 ff ff       	call   801000d0 <bread>
80102ca4:	89 c7                	mov    %eax,%edi
80102ca6:	8d 40 60             	lea    0x60(%eax),%eax
80102ca9:	83 c4 0c             	add    $0xc,%esp
80102cac:	68 00 02 00 00       	push   $0x200
80102cb1:	50                   	push   %eax
80102cb2:	8d 46 60             	lea    0x60(%esi),%eax
80102cb5:	50                   	push   %eax
80102cb6:	e8 e5 1a 00 00       	call   801047a0 <memmove>
80102cbb:	89 34 24             	mov    %esi,(%esp)
80102cbe:	e8 dd d4 ff ff       	call   801001a0 <bwrite>
80102cc3:	89 3c 24             	mov    %edi,(%esp)
80102cc6:	e8 15 d5 ff ff       	call   801001e0 <brelse>
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 0d d5 ff ff       	call   801001e0 <brelse>
80102cd3:	83 c4 10             	add    $0x10,%esp
80102cd6:	3b 1d 6c 28 11 80    	cmp    0x8011286c,%ebx
80102cdc:	7c 94                	jl     80102c72 <end_op+0x62>
80102cde:	e8 bd fd ff ff       	call   80102aa0 <write_head>
80102ce3:	e8 18 fd ff ff       	call   80102a00 <install_trans>
80102ce8:	c7 05 6c 28 11 80 00 	movl   $0x0,0x8011286c
80102cef:	00 00 00 
80102cf2:	e8 a9 fd ff ff       	call   80102aa0 <write_head>
80102cf7:	83 ec 0c             	sub    $0xc,%esp
80102cfa:	68 20 28 11 80       	push   $0x80112820
80102cff:	e8 cc 18 00 00       	call   801045d0 <acquire>
80102d04:	c7 04 24 20 28 11 80 	movl   $0x80112820,(%esp)
80102d0b:	c7 05 64 28 11 80 00 	movl   $0x0,0x80112864
80102d12:	00 00 00 
80102d15:	e8 16 12 00 00       	call   80103f30 <wakeup>
80102d1a:	c7 04 24 20 28 11 80 	movl   $0x80112820,(%esp)
80102d21:	e8 7a 19 00 00       	call   801046a0 <release>
80102d26:	83 c4 10             	add    $0x10,%esp
80102d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d2c:	5b                   	pop    %ebx
80102d2d:	5e                   	pop    %esi
80102d2e:	5f                   	pop    %edi
80102d2f:	5d                   	pop    %ebp
80102d30:	c3                   	ret    
80102d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d38:	83 ec 0c             	sub    $0xc,%esp
80102d3b:	68 20 28 11 80       	push   $0x80112820
80102d40:	e8 eb 11 00 00       	call   80103f30 <wakeup>
80102d45:	c7 04 24 20 28 11 80 	movl   $0x80112820,(%esp)
80102d4c:	e8 4f 19 00 00       	call   801046a0 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
80102d54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d57:	5b                   	pop    %ebx
80102d58:	5e                   	pop    %esi
80102d59:	5f                   	pop    %edi
80102d5a:	5d                   	pop    %ebp
80102d5b:	c3                   	ret    
80102d5c:	83 ec 0c             	sub    $0xc,%esp
80102d5f:	68 64 76 10 80       	push   $0x80107664
80102d64:	e8 27 d6 ff ff       	call   80100390 <panic>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <log_write>:
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 04             	sub    $0x4,%esp
80102d77:	8b 15 6c 28 11 80    	mov    0x8011286c,%edx
80102d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d80:	83 fa 1d             	cmp    $0x1d,%edx
80102d83:	0f 8f 9d 00 00 00    	jg     80102e26 <log_write+0xb6>
80102d89:	a1 5c 28 11 80       	mov    0x8011285c,%eax
80102d8e:	83 e8 01             	sub    $0x1,%eax
80102d91:	39 c2                	cmp    %eax,%edx
80102d93:	0f 8d 8d 00 00 00    	jge    80102e26 <log_write+0xb6>
80102d99:	a1 60 28 11 80       	mov    0x80112860,%eax
80102d9e:	85 c0                	test   %eax,%eax
80102da0:	0f 8e 8d 00 00 00    	jle    80102e33 <log_write+0xc3>
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 20 28 11 80       	push   $0x80112820
80102dae:	e8 1d 18 00 00       	call   801045d0 <acquire>
80102db3:	8b 0d 6c 28 11 80    	mov    0x8011286c,%ecx
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	83 f9 00             	cmp    $0x0,%ecx
80102dbf:	7e 57                	jle    80102e18 <log_write+0xa8>
80102dc1:	8b 53 08             	mov    0x8(%ebx),%edx
80102dc4:	31 c0                	xor    %eax,%eax
80102dc6:	3b 15 70 28 11 80    	cmp    0x80112870,%edx
80102dcc:	75 0b                	jne    80102dd9 <log_write+0x69>
80102dce:	eb 38                	jmp    80102e08 <log_write+0x98>
80102dd0:	39 14 85 70 28 11 80 	cmp    %edx,-0x7feed790(,%eax,4)
80102dd7:	74 2f                	je     80102e08 <log_write+0x98>
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	39 c1                	cmp    %eax,%ecx
80102dde:	75 f0                	jne    80102dd0 <log_write+0x60>
80102de0:	89 14 85 70 28 11 80 	mov    %edx,-0x7feed790(,%eax,4)
80102de7:	83 c0 01             	add    $0x1,%eax
80102dea:	a3 6c 28 11 80       	mov    %eax,0x8011286c
80102def:	83 0b 04             	orl    $0x4,(%ebx)
80102df2:	c7 45 08 20 28 11 80 	movl   $0x80112820,0x8(%ebp)
80102df9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dfc:	c9                   	leave  
80102dfd:	e9 9e 18 00 00       	jmp    801046a0 <release>
80102e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102e08:	89 14 85 70 28 11 80 	mov    %edx,-0x7feed790(,%eax,4)
80102e0f:	eb de                	jmp    80102def <log_write+0x7f>
80102e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e18:	8b 43 08             	mov    0x8(%ebx),%eax
80102e1b:	a3 70 28 11 80       	mov    %eax,0x80112870
80102e20:	75 cd                	jne    80102def <log_write+0x7f>
80102e22:	31 c0                	xor    %eax,%eax
80102e24:	eb c1                	jmp    80102de7 <log_write+0x77>
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	68 73 76 10 80       	push   $0x80107673
80102e2e:	e8 5d d5 ff ff       	call   80100390 <panic>
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	68 89 76 10 80       	push   $0x80107689
80102e3b:	e8 50 d5 ff ff       	call   80100390 <panic>

80102e40 <mpmain>:
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
80102e47:	e8 74 09 00 00       	call   801037c0 <cpuid>
80102e4c:	89 c3                	mov    %eax,%ebx
80102e4e:	e8 6d 09 00 00       	call   801037c0 <cpuid>
80102e53:	83 ec 04             	sub    $0x4,%esp
80102e56:	53                   	push   %ebx
80102e57:	50                   	push   %eax
80102e58:	68 a4 76 10 80       	push   $0x801076a4
80102e5d:	e8 fe d7 ff ff       	call   80100660 <cprintf>
80102e62:	e8 79 2b 00 00       	call   801059e0 <idtinit>
80102e67:	e8 d4 08 00 00       	call   80103740 <mycpu>
80102e6c:	89 c2                	mov    %eax,%edx
80102e6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
80102e7a:	e8 21 0c 00 00       	call   80103aa0 <scheduler>
80102e7f:	90                   	nop

80102e80 <mpenter>:
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	83 ec 08             	sub    $0x8,%esp
80102e86:	e8 45 3c 00 00       	call   80106ad0 <switchkvm>
80102e8b:	e8 b0 3b 00 00       	call   80106a40 <seginit>
80102e90:	e8 9b f7 ff ff       	call   80102630 <lapicinit>
80102e95:	e8 a6 ff ff ff       	call   80102e40 <mpmain>
80102e9a:	66 90                	xchg   %ax,%ax
80102e9c:	66 90                	xchg   %ax,%ax
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <main>:
80102ea0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ea4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ea7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eaa:	55                   	push   %ebp
80102eab:	89 e5                	mov    %esp,%ebp
80102ead:	53                   	push   %ebx
80102eae:	51                   	push   %ecx
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	68 00 00 40 80       	push   $0x80400000
80102eb7:	68 c8 56 11 80       	push   $0x801156c8
80102ebc:	e8 2f f5 ff ff       	call   801023f0 <kinit1>
80102ec1:	e8 da 40 00 00       	call   80106fa0 <kvmalloc>
80102ec6:	e8 75 01 00 00       	call   80103040 <mpinit>
80102ecb:	e8 60 f7 ff ff       	call   80102630 <lapicinit>
80102ed0:	e8 6b 3b 00 00       	call   80106a40 <seginit>
80102ed5:	e8 46 03 00 00       	call   80103220 <picinit>
80102eda:	e8 41 f3 ff ff       	call   80102220 <ioapicinit>
80102edf:	e8 dc da ff ff       	call   801009c0 <consoleinit>
80102ee4:	e8 27 2e 00 00       	call   80105d10 <uartinit>
80102ee9:	e8 32 08 00 00       	call   80103720 <pinit>
80102eee:	e8 6d 2a 00 00       	call   80105960 <tvinit>
80102ef3:	e8 48 d1 ff ff       	call   80100040 <binit>
80102ef8:	e8 63 de ff ff       	call   80100d60 <fileinit>
80102efd:	e8 fe f0 ff ff       	call   80102000 <ideinit>
80102f02:	83 c4 0c             	add    $0xc,%esp
80102f05:	68 8a 00 00 00       	push   $0x8a
80102f0a:	68 8c a4 10 80       	push   $0x8010a48c
80102f0f:	68 00 70 00 80       	push   $0x80007000
80102f14:	e8 87 18 00 00       	call   801047a0 <memmove>
80102f19:	69 05 a0 2e 11 80 b0 	imul   $0xb0,0x80112ea0,%eax
80102f20:	00 00 00 
80102f23:	83 c4 10             	add    $0x10,%esp
80102f26:	05 20 29 11 80       	add    $0x80112920,%eax
80102f2b:	3d 20 29 11 80       	cmp    $0x80112920,%eax
80102f30:	76 71                	jbe    80102fa3 <main+0x103>
80102f32:	bb 20 29 11 80       	mov    $0x80112920,%ebx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102f40:	e8 fb 07 00 00       	call   80103740 <mycpu>
80102f45:	39 d8                	cmp    %ebx,%eax
80102f47:	74 41                	je     80102f8a <main+0xea>
80102f49:	e8 72 f5 ff ff       	call   801024c0 <kalloc>
80102f4e:	05 00 10 00 00       	add    $0x1000,%eax
80102f53:	c7 05 f8 6f 00 80 80 	movl   $0x80102e80,0x80006ff8
80102f5a:	2e 10 80 
80102f5d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f64:	90 10 00 
80102f67:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
80102f6c:	0f b6 03             	movzbl (%ebx),%eax
80102f6f:	83 ec 08             	sub    $0x8,%esp
80102f72:	68 00 70 00 00       	push   $0x7000
80102f77:	50                   	push   %eax
80102f78:	e8 03 f8 ff ff       	call   80102780 <lapicstartap>
80102f7d:	83 c4 10             	add    $0x10,%esp
80102f80:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f86:	85 c0                	test   %eax,%eax
80102f88:	74 f6                	je     80102f80 <main+0xe0>
80102f8a:	69 05 a0 2e 11 80 b0 	imul   $0xb0,0x80112ea0,%eax
80102f91:	00 00 00 
80102f94:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f9a:	05 20 29 11 80       	add    $0x80112920,%eax
80102f9f:	39 c3                	cmp    %eax,%ebx
80102fa1:	72 9d                	jb     80102f40 <main+0xa0>
80102fa3:	83 ec 08             	sub    $0x8,%esp
80102fa6:	68 00 00 00 8e       	push   $0x8e000000
80102fab:	68 00 00 40 80       	push   $0x80400000
80102fb0:	e8 ab f4 ff ff       	call   80102460 <kinit2>
80102fb5:	e8 56 08 00 00       	call   80103810 <userinit>
80102fba:	e8 81 fe ff ff       	call   80102e40 <mpmain>
80102fbf:	90                   	nop

80102fc0 <mpsearch1>:
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
80102fc5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102fcb:	53                   	push   %ebx
80102fcc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
80102fcf:	83 ec 0c             	sub    $0xc,%esp
80102fd2:	39 de                	cmp    %ebx,%esi
80102fd4:	72 10                	jb     80102fe6 <mpsearch1+0x26>
80102fd6:	eb 50                	jmp    80103028 <mpsearch1+0x68>
80102fd8:	90                   	nop
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe0:	39 fb                	cmp    %edi,%ebx
80102fe2:	89 fe                	mov    %edi,%esi
80102fe4:	76 42                	jbe    80103028 <mpsearch1+0x68>
80102fe6:	83 ec 04             	sub    $0x4,%esp
80102fe9:	8d 7e 10             	lea    0x10(%esi),%edi
80102fec:	6a 04                	push   $0x4
80102fee:	68 b8 76 10 80       	push   $0x801076b8
80102ff3:	56                   	push   %esi
80102ff4:	e8 47 17 00 00       	call   80104740 <memcmp>
80102ff9:	83 c4 10             	add    $0x10,%esp
80102ffc:	85 c0                	test   %eax,%eax
80102ffe:	75 e0                	jne    80102fe0 <mpsearch1+0x20>
80103000:	89 f1                	mov    %esi,%ecx
80103002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103008:	0f b6 11             	movzbl (%ecx),%edx
8010300b:	83 c1 01             	add    $0x1,%ecx
8010300e:	01 d0                	add    %edx,%eax
80103010:	39 f9                	cmp    %edi,%ecx
80103012:	75 f4                	jne    80103008 <mpsearch1+0x48>
80103014:	84 c0                	test   %al,%al
80103016:	75 c8                	jne    80102fe0 <mpsearch1+0x20>
80103018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010301b:	89 f0                	mov    %esi,%eax
8010301d:	5b                   	pop    %ebx
8010301e:	5e                   	pop    %esi
8010301f:	5f                   	pop    %edi
80103020:	5d                   	pop    %ebp
80103021:	c3                   	ret    
80103022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302b:	31 f6                	xor    %esi,%esi
8010302d:	89 f0                	mov    %esi,%eax
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
80103034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010303a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103040 <mpinit>:
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 1c             	sub    $0x1c,%esp
80103049:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103050:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103057:	c1 e0 08             	shl    $0x8,%eax
8010305a:	09 d0                	or     %edx,%eax
8010305c:	c1 e0 04             	shl    $0x4,%eax
8010305f:	85 c0                	test   %eax,%eax
80103061:	75 1b                	jne    8010307e <mpinit+0x3e>
80103063:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010306a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103071:	c1 e0 08             	shl    $0x8,%eax
80103074:	09 d0                	or     %edx,%eax
80103076:	c1 e0 0a             	shl    $0xa,%eax
80103079:	2d 00 04 00 00       	sub    $0x400,%eax
8010307e:	ba 00 04 00 00       	mov    $0x400,%edx
80103083:	e8 38 ff ff ff       	call   80102fc0 <mpsearch1>
80103088:	85 c0                	test   %eax,%eax
8010308a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010308d:	0f 84 3d 01 00 00    	je     801031d0 <mpinit+0x190>
80103093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103096:	8b 58 04             	mov    0x4(%eax),%ebx
80103099:	85 db                	test   %ebx,%ebx
8010309b:	0f 84 4f 01 00 00    	je     801031f0 <mpinit+0x1b0>
801030a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
801030a7:	83 ec 04             	sub    $0x4,%esp
801030aa:	6a 04                	push   $0x4
801030ac:	68 d5 76 10 80       	push   $0x801076d5
801030b1:	56                   	push   %esi
801030b2:	e8 89 16 00 00       	call   80104740 <memcmp>
801030b7:	83 c4 10             	add    $0x10,%esp
801030ba:	85 c0                	test   %eax,%eax
801030bc:	0f 85 2e 01 00 00    	jne    801031f0 <mpinit+0x1b0>
801030c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030c9:	3c 01                	cmp    $0x1,%al
801030cb:	0f 95 c2             	setne  %dl
801030ce:	3c 04                	cmp    $0x4,%al
801030d0:	0f 95 c0             	setne  %al
801030d3:	20 c2                	and    %al,%dl
801030d5:	0f 85 15 01 00 00    	jne    801031f0 <mpinit+0x1b0>
801030db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
801030e2:	66 85 ff             	test   %di,%di
801030e5:	74 1a                	je     80103101 <mpinit+0xc1>
801030e7:	89 f0                	mov    %esi,%eax
801030e9:	01 f7                	add    %esi,%edi
801030eb:	31 d2                	xor    %edx,%edx
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
801030f0:	0f b6 08             	movzbl (%eax),%ecx
801030f3:	83 c0 01             	add    $0x1,%eax
801030f6:	01 ca                	add    %ecx,%edx
801030f8:	39 c7                	cmp    %eax,%edi
801030fa:	75 f4                	jne    801030f0 <mpinit+0xb0>
801030fc:	84 d2                	test   %dl,%dl
801030fe:	0f 95 c2             	setne  %dl
80103101:	85 f6                	test   %esi,%esi
80103103:	0f 84 e7 00 00 00    	je     801031f0 <mpinit+0x1b0>
80103109:	84 d2                	test   %dl,%dl
8010310b:	0f 85 df 00 00 00    	jne    801031f0 <mpinit+0x1b0>
80103111:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103117:	a3 00 28 11 80       	mov    %eax,0x80112800
8010311c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103123:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103129:	bb 01 00 00 00       	mov    $0x1,%ebx
8010312e:	01 d6                	add    %edx,%esi
80103130:	39 c6                	cmp    %eax,%esi
80103132:	76 23                	jbe    80103157 <mpinit+0x117>
80103134:	0f b6 10             	movzbl (%eax),%edx
80103137:	80 fa 04             	cmp    $0x4,%dl
8010313a:	0f 87 ca 00 00 00    	ja     8010320a <mpinit+0x1ca>
80103140:	ff 24 95 fc 76 10 80 	jmp    *-0x7fef8904(,%edx,4)
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103150:	83 c0 08             	add    $0x8,%eax
80103153:	39 c6                	cmp    %eax,%esi
80103155:	77 dd                	ja     80103134 <mpinit+0xf4>
80103157:	85 db                	test   %ebx,%ebx
80103159:	0f 84 9e 00 00 00    	je     801031fd <mpinit+0x1bd>
8010315f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103162:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103166:	74 15                	je     8010317d <mpinit+0x13d>
80103168:	b8 70 00 00 00       	mov    $0x70,%eax
8010316d:	ba 22 00 00 00       	mov    $0x22,%edx
80103172:	ee                   	out    %al,(%dx)
80103173:	ba 23 00 00 00       	mov    $0x23,%edx
80103178:	ec                   	in     (%dx),%al
80103179:	83 c8 01             	or     $0x1,%eax
8010317c:	ee                   	out    %al,(%dx)
8010317d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103180:	5b                   	pop    %ebx
80103181:	5e                   	pop    %esi
80103182:	5f                   	pop    %edi
80103183:	5d                   	pop    %ebp
80103184:	c3                   	ret    
80103185:	8d 76 00             	lea    0x0(%esi),%esi
80103188:	8b 0d a0 2e 11 80    	mov    0x80112ea0,%ecx
8010318e:	83 f9 07             	cmp    $0x7,%ecx
80103191:	7f 19                	jg     801031ac <mpinit+0x16c>
80103193:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103197:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
8010319d:	83 c1 01             	add    $0x1,%ecx
801031a0:	89 0d a0 2e 11 80    	mov    %ecx,0x80112ea0
801031a6:	88 97 20 29 11 80    	mov    %dl,-0x7feed6e0(%edi)
801031ac:	83 c0 14             	add    $0x14,%eax
801031af:	e9 7c ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031bc:	83 c0 08             	add    $0x8,%eax
801031bf:	88 15 00 29 11 80    	mov    %dl,0x80112900
801031c5:	e9 66 ff ff ff       	jmp    80103130 <mpinit+0xf0>
801031ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031da:	e8 e1 fd ff ff       	call   80102fc0 <mpsearch1>
801031df:	85 c0                	test   %eax,%eax
801031e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801031e4:	0f 85 a9 fe ff ff    	jne    80103093 <mpinit+0x53>
801031ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 bd 76 10 80       	push   $0x801076bd
801031f8:	e8 93 d1 ff ff       	call   80100390 <panic>
801031fd:	83 ec 0c             	sub    $0xc,%esp
80103200:	68 dc 76 10 80       	push   $0x801076dc
80103205:	e8 86 d1 ff ff       	call   80100390 <panic>
8010320a:	31 db                	xor    %ebx,%ebx
8010320c:	e9 26 ff ff ff       	jmp    80103137 <mpinit+0xf7>
80103211:	66 90                	xchg   %ax,%ax
80103213:	66 90                	xchg   %ax,%ax
80103215:	66 90                	xchg   %ax,%ax
80103217:	66 90                	xchg   %ax,%ax
80103219:	66 90                	xchg   %ax,%ax
8010321b:	66 90                	xchg   %ax,%ax
8010321d:	66 90                	xchg   %ax,%ax
8010321f:	90                   	nop

80103220 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103220:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103226:	ba 21 00 00 00       	mov    $0x21,%edx
8010322b:	89 e5                	mov    %esp,%ebp
8010322d:	ee                   	out    %al,(%dx)
8010322e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103233:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103234:	5d                   	pop    %ebp
80103235:	c3                   	ret    
80103236:	66 90                	xchg   %ax,%ax
80103238:	66 90                	xchg   %ax,%ax
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <pipealloc>:
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
80103245:	53                   	push   %ebx
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010324c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010324f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103255:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010325b:	e8 20 db ff ff       	call   80100d80 <filealloc>
80103260:	85 c0                	test   %eax,%eax
80103262:	89 03                	mov    %eax,(%ebx)
80103264:	74 22                	je     80103288 <pipealloc+0x48>
80103266:	e8 15 db ff ff       	call   80100d80 <filealloc>
8010326b:	85 c0                	test   %eax,%eax
8010326d:	89 06                	mov    %eax,(%esi)
8010326f:	74 3f                	je     801032b0 <pipealloc+0x70>
80103271:	e8 4a f2 ff ff       	call   801024c0 <kalloc>
80103276:	85 c0                	test   %eax,%eax
80103278:	89 c7                	mov    %eax,%edi
8010327a:	75 54                	jne    801032d0 <pipealloc+0x90>
8010327c:	8b 03                	mov    (%ebx),%eax
8010327e:	85 c0                	test   %eax,%eax
80103280:	75 34                	jne    801032b6 <pipealloc+0x76>
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103288:	8b 06                	mov    (%esi),%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	74 0c                	je     8010329a <pipealloc+0x5a>
8010328e:	83 ec 0c             	sub    $0xc,%esp
80103291:	50                   	push   %eax
80103292:	e8 a9 db ff ff       	call   80100e40 <fileclose>
80103297:	83 c4 10             	add    $0x10,%esp
8010329a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010329d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032a2:	5b                   	pop    %ebx
801032a3:	5e                   	pop    %esi
801032a4:	5f                   	pop    %edi
801032a5:	5d                   	pop    %ebp
801032a6:	c3                   	ret    
801032a7:	89 f6                	mov    %esi,%esi
801032a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801032b0:	8b 03                	mov    (%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 e4                	je     8010329a <pipealloc+0x5a>
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 81 db ff ff       	call   80100e40 <fileclose>
801032bf:	8b 06                	mov    (%esi),%eax
801032c1:	83 c4 10             	add    $0x10,%esp
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 c6                	jne    8010328e <pipealloc+0x4e>
801032c8:	eb d0                	jmp    8010329a <pipealloc+0x5a>
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032d0:	83 ec 08             	sub    $0x8,%esp
801032d3:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032da:	00 00 00 
801032dd:	c7 80 44 02 00 00 01 	movl   $0x1,0x244(%eax)
801032e4:	00 00 00 
801032e7:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801032ee:	00 00 00 
801032f1:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032f8:	00 00 00 
801032fb:	68 10 77 10 80       	push   $0x80107710
80103300:	50                   	push   %eax
80103301:	e8 6a 11 00 00       	call   80104470 <initlock>
80103306:	8b 03                	mov    (%ebx),%eax
80103308:	83 c4 10             	add    $0x10,%esp
8010330b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
80103311:	8b 03                	mov    (%ebx),%eax
80103313:	c6 40 08 01          	movb   $0x1,0x8(%eax)
80103317:	8b 03                	mov    (%ebx),%eax
80103319:	c6 40 09 00          	movb   $0x0,0x9(%eax)
8010331d:	8b 03                	mov    (%ebx),%eax
8010331f:	89 78 0c             	mov    %edi,0xc(%eax)
80103322:	8b 06                	mov    (%esi),%eax
80103324:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
8010332a:	8b 06                	mov    (%esi),%eax
8010332c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
80103330:	8b 06                	mov    (%esi),%eax
80103332:	c6 40 09 01          	movb   $0x1,0x9(%eax)
80103336:	8b 06                	mov    (%esi),%eax
80103338:	89 78 0c             	mov    %edi,0xc(%eax)
8010333b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333e:	31 c0                	xor    %eax,%eax
80103340:	5b                   	pop    %ebx
80103341:	5e                   	pop    %esi
80103342:	5f                   	pop    %edi
80103343:	5d                   	pop    %ebp
80103344:	c3                   	ret    
80103345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103350 <pipeclose>:
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	56                   	push   %esi
80103354:	53                   	push   %ebx
80103355:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103358:	8b 75 0c             	mov    0xc(%ebp),%esi
8010335b:	83 ec 0c             	sub    $0xc,%esp
8010335e:	53                   	push   %ebx
8010335f:	e8 6c 12 00 00       	call   801045d0 <acquire>
80103364:	83 c4 10             	add    $0x10,%esp
80103367:	85 f6                	test   %esi,%esi
80103369:	74 45                	je     801033b0 <pipeclose+0x60>
8010336b:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103371:	83 ec 0c             	sub    $0xc,%esp
80103374:	c7 83 44 02 00 00 00 	movl   $0x0,0x244(%ebx)
8010337b:	00 00 00 
8010337e:	50                   	push   %eax
8010337f:	e8 ac 0b 00 00       	call   80103f30 <wakeup>
80103384:	83 c4 10             	add    $0x10,%esp
80103387:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
8010338d:	85 d2                	test   %edx,%edx
8010338f:	75 0a                	jne    8010339b <pipeclose+0x4b>
80103391:	8b 83 44 02 00 00    	mov    0x244(%ebx),%eax
80103397:	85 c0                	test   %eax,%eax
80103399:	74 35                	je     801033d0 <pipeclose+0x80>
8010339b:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010339e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033a1:	5b                   	pop    %ebx
801033a2:	5e                   	pop    %esi
801033a3:	5d                   	pop    %ebp
801033a4:	e9 f7 12 00 00       	jmp    801046a0 <release>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033b0:	8d 83 3c 02 00 00    	lea    0x23c(%ebx),%eax
801033b6:	83 ec 0c             	sub    $0xc,%esp
801033b9:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033c0:	00 00 00 
801033c3:	50                   	push   %eax
801033c4:	e8 67 0b 00 00       	call   80103f30 <wakeup>
801033c9:	83 c4 10             	add    $0x10,%esp
801033cc:	eb b9                	jmp    80103387 <pipeclose+0x37>
801033ce:	66 90                	xchg   %ax,%ax
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	53                   	push   %ebx
801033d4:	e8 c7 12 00 00       	call   801046a0 <release>
801033d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033dc:	83 c4 10             	add    $0x10,%esp
801033df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e2:	5b                   	pop    %ebx
801033e3:	5e                   	pop    %esi
801033e4:	5d                   	pop    %ebp
801033e5:	e9 26 ef ff ff       	jmp    80102310 <kfree>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801033f0 <pipewrite>:
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 28             	sub    $0x28,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033fc:	53                   	push   %ebx
801033fd:	e8 ce 11 00 00       	call   801045d0 <acquire>
80103402:	8b 45 10             	mov    0x10(%ebp),%eax
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	85 c0                	test   %eax,%eax
8010340a:	0f 8e c9 00 00 00    	jle    801034d9 <pipewrite+0xe9>
80103410:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103413:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103419:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
8010341f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103422:	03 4d 10             	add    0x10(%ebp),%ecx
80103425:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80103428:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
8010342e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103434:	39 d0                	cmp    %edx,%eax
80103436:	75 71                	jne    801034a9 <pipewrite+0xb9>
80103438:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 4e                	je     80103490 <pipewrite+0xa0>
80103442:	8d b3 3c 02 00 00    	lea    0x23c(%ebx),%esi
80103448:	eb 3a                	jmp    80103484 <pipewrite+0x94>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103450:	83 ec 0c             	sub    $0xc,%esp
80103453:	57                   	push   %edi
80103454:	e8 d7 0a 00 00       	call   80103f30 <wakeup>
80103459:	5a                   	pop    %edx
8010345a:	59                   	pop    %ecx
8010345b:	53                   	push   %ebx
8010345c:	56                   	push   %esi
8010345d:	e8 1e 09 00 00       	call   80103d80 <sleep>
80103462:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103468:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	05 00 02 00 00       	add    $0x200,%eax
80103476:	39 c2                	cmp    %eax,%edx
80103478:	75 36                	jne    801034b0 <pipewrite+0xc0>
8010347a:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103480:	85 c0                	test   %eax,%eax
80103482:	74 0c                	je     80103490 <pipewrite+0xa0>
80103484:	e8 57 03 00 00       	call   801037e0 <myproc>
80103489:	8b 40 24             	mov    0x24(%eax),%eax
8010348c:	85 c0                	test   %eax,%eax
8010348e:	74 c0                	je     80103450 <pipewrite+0x60>
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	53                   	push   %ebx
80103494:	e8 07 12 00 00       	call   801046a0 <release>
80103499:	83 c4 10             	add    $0x10,%esp
8010349c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034a4:	5b                   	pop    %ebx
801034a5:	5e                   	pop    %esi
801034a6:	5f                   	pop    %edi
801034a7:	5d                   	pop    %ebp
801034a8:	c3                   	ret    
801034a9:	89 c2                	mov    %eax,%edx
801034ab:	90                   	nop
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034b3:	8d 42 01             	lea    0x1(%edx),%eax
801034b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034bc:	89 83 3c 02 00 00    	mov    %eax,0x23c(%ebx)
801034c2:	83 c6 01             	add    $0x1,%esi
801034c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
801034c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801034cf:	88 4c 13 38          	mov    %cl,0x38(%ebx,%edx,1)
801034d3:	0f 85 4f ff ff ff    	jne    80103428 <pipewrite+0x38>
801034d9:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801034df:	83 ec 0c             	sub    $0xc,%esp
801034e2:	50                   	push   %eax
801034e3:	e8 48 0a 00 00       	call   80103f30 <wakeup>
801034e8:	89 1c 24             	mov    %ebx,(%esp)
801034eb:	e8 b0 11 00 00       	call   801046a0 <release>
801034f0:	83 c4 10             	add    $0x10,%esp
801034f3:	8b 45 10             	mov    0x10(%ebp),%eax
801034f6:	eb a9                	jmp    801034a1 <pipewrite+0xb1>
801034f8:	90                   	nop
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103500 <piperead>:
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 18             	sub    $0x18,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010350f:	56                   	push   %esi
80103510:	e8 bb 10 00 00       	call   801045d0 <acquire>
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
8010351e:	3b 8e 3c 02 00 00    	cmp    0x23c(%esi),%ecx
80103524:	75 6a                	jne    80103590 <piperead+0x90>
80103526:	8b 9e 44 02 00 00    	mov    0x244(%esi),%ebx
8010352c:	85 db                	test   %ebx,%ebx
8010352e:	0f 84 c4 00 00 00    	je     801035f8 <piperead+0xf8>
80103534:	8d 9e 38 02 00 00    	lea    0x238(%esi),%ebx
8010353a:	eb 2d                	jmp    80103569 <piperead+0x69>
8010353c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103540:	83 ec 08             	sub    $0x8,%esp
80103543:	56                   	push   %esi
80103544:	53                   	push   %ebx
80103545:	e8 36 08 00 00       	call   80103d80 <sleep>
8010354a:	83 c4 10             	add    $0x10,%esp
8010354d:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
80103553:	3b 8e 3c 02 00 00    	cmp    0x23c(%esi),%ecx
80103559:	75 35                	jne    80103590 <piperead+0x90>
8010355b:	8b 96 44 02 00 00    	mov    0x244(%esi),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	0f 84 8f 00 00 00    	je     801035f8 <piperead+0xf8>
80103569:	e8 72 02 00 00       	call   801037e0 <myproc>
8010356e:	8b 48 24             	mov    0x24(%eax),%ecx
80103571:	85 c9                	test   %ecx,%ecx
80103573:	74 cb                	je     80103540 <piperead+0x40>
80103575:	83 ec 0c             	sub    $0xc,%esp
80103578:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010357d:	56                   	push   %esi
8010357e:	e8 1d 11 00 00       	call   801046a0 <release>
80103583:	83 c4 10             	add    $0x10,%esp
80103586:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103589:	89 d8                	mov    %ebx,%eax
8010358b:	5b                   	pop    %ebx
8010358c:	5e                   	pop    %esi
8010358d:	5f                   	pop    %edi
8010358e:	5d                   	pop    %ebp
8010358f:	c3                   	ret    
80103590:	8b 45 10             	mov    0x10(%ebp),%eax
80103593:	85 c0                	test   %eax,%eax
80103595:	7e 61                	jle    801035f8 <piperead+0xf8>
80103597:	31 db                	xor    %ebx,%ebx
80103599:	eb 13                	jmp    801035ae <piperead+0xae>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	8b 8e 38 02 00 00    	mov    0x238(%esi),%ecx
801035a6:	3b 8e 3c 02 00 00    	cmp    0x23c(%esi),%ecx
801035ac:	74 1f                	je     801035cd <piperead+0xcd>
801035ae:	8d 41 01             	lea    0x1(%ecx),%eax
801035b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035b7:	89 86 38 02 00 00    	mov    %eax,0x238(%esi)
801035bd:	0f b6 44 0e 38       	movzbl 0x38(%esi,%ecx,1),%eax
801035c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
801035c5:	83 c3 01             	add    $0x1,%ebx
801035c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035cb:	75 d3                	jne    801035a0 <piperead+0xa0>
801035cd:	8d 86 3c 02 00 00    	lea    0x23c(%esi),%eax
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	50                   	push   %eax
801035d7:	e8 54 09 00 00       	call   80103f30 <wakeup>
801035dc:	89 34 24             	mov    %esi,(%esp)
801035df:	e8 bc 10 00 00       	call   801046a0 <release>
801035e4:	83 c4 10             	add    $0x10,%esp
801035e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ea:	89 d8                	mov    %ebx,%eax
801035ec:	5b                   	pop    %ebx
801035ed:	5e                   	pop    %esi
801035ee:	5f                   	pop    %edi
801035ef:	5d                   	pop    %ebp
801035f0:	c3                   	ret    
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035f8:	31 db                	xor    %ebx,%ebx
801035fa:	eb d1                	jmp    801035cd <piperead+0xcd>
801035fc:	66 90                	xchg   %ax,%ax
801035fe:	66 90                	xchg   %ax,%ax

80103600 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103604:	bb f8 2e 11 80       	mov    $0x80112ef8,%ebx
{
80103609:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010360c:	68 c0 2e 11 80       	push   $0x80112ec0
80103611:	e8 ba 0f 00 00       	call   801045d0 <acquire>
80103616:	83 c4 10             	add    $0x10,%esp
80103619:	eb 10                	jmp    8010362b <allocproc+0x2b>
8010361b:	90                   	nop
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103620:	83 c3 7c             	add    $0x7c,%ebx
80103623:	81 fb f8 4d 11 80    	cmp    $0x80114df8,%ebx
80103629:	73 75                	jae    801036a0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010362b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010362e:	85 c0                	test   %eax,%eax
80103630:	75 ee                	jne    80103620 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103632:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103637:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010363a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103641:	8d 50 01             	lea    0x1(%eax),%edx
80103644:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103647:	68 c0 2e 11 80       	push   $0x80112ec0
  p->pid = nextpid++;
8010364c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103652:	e8 49 10 00 00       	call   801046a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103657:	e8 64 ee ff ff       	call   801024c0 <kalloc>
8010365c:	83 c4 10             	add    $0x10,%esp
8010365f:	85 c0                	test   %eax,%eax
80103661:	89 43 08             	mov    %eax,0x8(%ebx)
80103664:	74 53                	je     801036b9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103666:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010366c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010366f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103674:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103677:	c7 40 14 47 59 10 80 	movl   $0x80105947,0x14(%eax)
  p->context = (struct context*)sp;
8010367e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103681:	6a 14                	push   $0x14
80103683:	6a 00                	push   $0x0
80103685:	50                   	push   %eax
80103686:	e8 65 10 00 00       	call   801046f0 <memset>
  p->context->eip = (uint)forkret;
8010368b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010368e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103691:	c7 40 10 d0 36 10 80 	movl   $0x801036d0,0x10(%eax)
}
80103698:	89 d8                	mov    %ebx,%eax
8010369a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010369d:	c9                   	leave  
8010369e:	c3                   	ret    
8010369f:	90                   	nop
  release(&ptable.lock);
801036a0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801036a3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801036a5:	68 c0 2e 11 80       	push   $0x80112ec0
801036aa:	e8 f1 0f 00 00       	call   801046a0 <release>
}
801036af:	89 d8                	mov    %ebx,%eax
  return 0;
801036b1:	83 c4 10             	add    $0x10,%esp
}
801036b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036b7:	c9                   	leave  
801036b8:	c3                   	ret    
    p->state = UNUSED;
801036b9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801036c0:	31 db                	xor    %ebx,%ebx
801036c2:	eb d4                	jmp    80103698 <allocproc+0x98>
801036c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801036d6:	68 c0 2e 11 80       	push   $0x80112ec0
801036db:	e8 c0 0f 00 00       	call   801046a0 <release>

  if (first) {
801036e0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801036e5:	83 c4 10             	add    $0x10,%esp
801036e8:	85 c0                	test   %eax,%eax
801036ea:	75 04                	jne    801036f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036ec:	c9                   	leave  
801036ed:	c3                   	ret    
801036ee:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801036f0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801036f3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801036fa:	00 00 00 
    iinit(ROOTDEV);
801036fd:	6a 01                	push   $0x1
801036ff:	e8 7c dd ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103704:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010370b:	e8 f0 f3 ff ff       	call   80102b00 <initlog>
80103710:	83 c4 10             	add    $0x10,%esp
}
80103713:	c9                   	leave  
80103714:	c3                   	ret    
80103715:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103720 <pinit>:
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103726:	68 15 77 10 80       	push   $0x80107715
8010372b:	68 c0 2e 11 80       	push   $0x80112ec0
80103730:	e8 3b 0d 00 00       	call   80104470 <initlock>
}
80103735:	83 c4 10             	add    $0x10,%esp
80103738:	c9                   	leave  
80103739:	c3                   	ret    
8010373a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103740 <mycpu>:
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	56                   	push   %esi
80103744:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103745:	9c                   	pushf  
80103746:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103747:	f6 c4 02             	test   $0x2,%ah
8010374a:	75 5e                	jne    801037aa <mycpu+0x6a>
  apicid = lapicid();
8010374c:	e8 df ef ff ff       	call   80102730 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103751:	8b 35 a0 2e 11 80    	mov    0x80112ea0,%esi
80103757:	85 f6                	test   %esi,%esi
80103759:	7e 42                	jle    8010379d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010375b:	0f b6 15 20 29 11 80 	movzbl 0x80112920,%edx
80103762:	39 d0                	cmp    %edx,%eax
80103764:	74 30                	je     80103796 <mycpu+0x56>
80103766:	b9 d0 29 11 80       	mov    $0x801129d0,%ecx
  for (i = 0; i < ncpu; ++i) {
8010376b:	31 d2                	xor    %edx,%edx
8010376d:	8d 76 00             	lea    0x0(%esi),%esi
80103770:	83 c2 01             	add    $0x1,%edx
80103773:	39 f2                	cmp    %esi,%edx
80103775:	74 26                	je     8010379d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103777:	0f b6 19             	movzbl (%ecx),%ebx
8010377a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103780:	39 c3                	cmp    %eax,%ebx
80103782:	75 ec                	jne    80103770 <mycpu+0x30>
80103784:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010378a:	05 20 29 11 80       	add    $0x80112920,%eax
}
8010378f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103792:	5b                   	pop    %ebx
80103793:	5e                   	pop    %esi
80103794:	5d                   	pop    %ebp
80103795:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103796:	b8 20 29 11 80       	mov    $0x80112920,%eax
      return &cpus[i];
8010379b:	eb f2                	jmp    8010378f <mycpu+0x4f>
  panic("unknown apicid\n");
8010379d:	83 ec 0c             	sub    $0xc,%esp
801037a0:	68 1c 77 10 80       	push   $0x8010771c
801037a5:	e8 e6 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801037aa:	83 ec 0c             	sub    $0xc,%esp
801037ad:	68 5c 78 10 80       	push   $0x8010785c
801037b2:	e8 d9 cb ff ff       	call   80100390 <panic>
801037b7:	89 f6                	mov    %esi,%esi
801037b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037c0 <cpuid>:
cpuid() {
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037c6:	e8 75 ff ff ff       	call   80103740 <mycpu>
801037cb:	2d 20 29 11 80       	sub    $0x80112920,%eax
}
801037d0:	c9                   	leave  
  return mycpu()-cpus;
801037d1:	c1 f8 04             	sar    $0x4,%eax
801037d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037da:	c3                   	ret    
801037db:	90                   	nop
801037dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037e0 <myproc>:
myproc(void) {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
801037e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801037e7:	e8 14 0d 00 00       	call   80104500 <pushcli>
  c = mycpu();
801037ec:	e8 4f ff ff ff       	call   80103740 <mycpu>
  p = c->proc;
801037f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037f7:	e8 44 0d 00 00       	call   80104540 <popcli>
}
801037fc:	83 c4 04             	add    $0x4,%esp
801037ff:	89 d8                	mov    %ebx,%eax
80103801:	5b                   	pop    %ebx
80103802:	5d                   	pop    %ebp
80103803:	c3                   	ret    
80103804:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010380a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103810 <userinit>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
80103814:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103817:	e8 e4 fd ff ff       	call   80103600 <allocproc>
8010381c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010381e:	a3 bc a5 10 80       	mov    %eax,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
80103823:	e8 f8 36 00 00       	call   80106f20 <setupkvm>
80103828:	85 c0                	test   %eax,%eax
8010382a:	89 43 04             	mov    %eax,0x4(%ebx)
8010382d:	0f 84 bd 00 00 00    	je     801038f0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103833:	83 ec 04             	sub    $0x4,%esp
80103836:	68 2c 00 00 00       	push   $0x2c
8010383b:	68 60 a4 10 80       	push   $0x8010a460
80103840:	50                   	push   %eax
80103841:	e8 ba 33 00 00       	call   80106c00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103846:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103849:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010384f:	6a 4c                	push   $0x4c
80103851:	6a 00                	push   $0x0
80103853:	ff 73 18             	pushl  0x18(%ebx)
80103856:	e8 95 0e 00 00       	call   801046f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010385b:	8b 43 18             	mov    0x18(%ebx),%eax
8010385e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103863:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103868:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010386b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010386f:	8b 43 18             	mov    0x18(%ebx),%eax
80103872:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103876:	8b 43 18             	mov    0x18(%ebx),%eax
80103879:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010387d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103881:	8b 43 18             	mov    0x18(%ebx),%eax
80103884:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103888:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010388c:	8b 43 18             	mov    0x18(%ebx),%eax
8010388f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103896:	8b 43 18             	mov    0x18(%ebx),%eax
80103899:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038a0:	8b 43 18             	mov    0x18(%ebx),%eax
801038a3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038aa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801038ad:	6a 10                	push   $0x10
801038af:	68 45 77 10 80       	push   $0x80107745
801038b4:	50                   	push   %eax
801038b5:	e8 16 10 00 00       	call   801048d0 <safestrcpy>
  p->cwd = namei("/");
801038ba:	c7 04 24 4e 77 10 80 	movl   $0x8010774e,(%esp)
801038c1:	e8 1a e6 ff ff       	call   80101ee0 <namei>
801038c6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801038c9:	c7 04 24 c0 2e 11 80 	movl   $0x80112ec0,(%esp)
801038d0:	e8 fb 0c 00 00       	call   801045d0 <acquire>
  p->state = RUNNABLE;
801038d5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801038dc:	c7 04 24 c0 2e 11 80 	movl   $0x80112ec0,(%esp)
801038e3:	e8 b8 0d 00 00       	call   801046a0 <release>
}
801038e8:	83 c4 10             	add    $0x10,%esp
801038eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ee:	c9                   	leave  
801038ef:	c3                   	ret    
    panic("userinit: out of memory?");
801038f0:	83 ec 0c             	sub    $0xc,%esp
801038f3:	68 2c 77 10 80       	push   $0x8010772c
801038f8:	e8 93 ca ff ff       	call   80100390 <panic>
801038fd:	8d 76 00             	lea    0x0(%esi),%esi

80103900 <growproc>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
80103905:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103908:	e8 f3 0b 00 00       	call   80104500 <pushcli>
  c = mycpu();
8010390d:	e8 2e fe ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103912:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103918:	e8 23 0c 00 00       	call   80104540 <popcli>
  if(n > 0){
8010391d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103920:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103922:	7f 1c                	jg     80103940 <growproc+0x40>
  } else if(n < 0){
80103924:	75 3a                	jne    80103960 <growproc+0x60>
  switchuvm(curproc);
80103926:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103929:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010392b:	53                   	push   %ebx
8010392c:	e8 bf 31 00 00       	call   80106af0 <switchuvm>
  return 0;
80103931:	83 c4 10             	add    $0x10,%esp
80103934:	31 c0                	xor    %eax,%eax
}
80103936:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103939:	5b                   	pop    %ebx
8010393a:	5e                   	pop    %esi
8010393b:	5d                   	pop    %ebp
8010393c:	c3                   	ret    
8010393d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103940:	83 ec 04             	sub    $0x4,%esp
80103943:	01 c6                	add    %eax,%esi
80103945:	56                   	push   %esi
80103946:	50                   	push   %eax
80103947:	ff 73 04             	pushl  0x4(%ebx)
8010394a:	e8 f1 33 00 00       	call   80106d40 <allocuvm>
8010394f:	83 c4 10             	add    $0x10,%esp
80103952:	85 c0                	test   %eax,%eax
80103954:	75 d0                	jne    80103926 <growproc+0x26>
      return -1;
80103956:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010395b:	eb d9                	jmp    80103936 <growproc+0x36>
8010395d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103960:	83 ec 04             	sub    $0x4,%esp
80103963:	01 c6                	add    %eax,%esi
80103965:	56                   	push   %esi
80103966:	50                   	push   %eax
80103967:	ff 73 04             	pushl  0x4(%ebx)
8010396a:	e8 01 35 00 00       	call   80106e70 <deallocuvm>
8010396f:	83 c4 10             	add    $0x10,%esp
80103972:	85 c0                	test   %eax,%eax
80103974:	75 b0                	jne    80103926 <growproc+0x26>
80103976:	eb de                	jmp    80103956 <growproc+0x56>
80103978:	90                   	nop
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103980 <fork>:
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103989:	e8 72 0b 00 00       	call   80104500 <pushcli>
  c = mycpu();
8010398e:	e8 ad fd ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103993:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103999:	e8 a2 0b 00 00       	call   80104540 <popcli>
  if((np = allocproc()) == 0){
8010399e:	e8 5d fc ff ff       	call   80103600 <allocproc>
801039a3:	85 c0                	test   %eax,%eax
801039a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039a8:	0f 84 b7 00 00 00    	je     80103a65 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039ae:	83 ec 08             	sub    $0x8,%esp
801039b1:	ff 33                	pushl  (%ebx)
801039b3:	ff 73 04             	pushl  0x4(%ebx)
801039b6:	89 c7                	mov    %eax,%edi
801039b8:	e8 33 36 00 00       	call   80106ff0 <copyuvm>
801039bd:	83 c4 10             	add    $0x10,%esp
801039c0:	85 c0                	test   %eax,%eax
801039c2:	89 47 04             	mov    %eax,0x4(%edi)
801039c5:	0f 84 a1 00 00 00    	je     80103a6c <fork+0xec>
  np->sz = curproc->sz;
801039cb:	8b 03                	mov    (%ebx),%eax
801039cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801039d0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801039d2:	89 59 14             	mov    %ebx,0x14(%ecx)
801039d5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
801039d7:	8b 79 18             	mov    0x18(%ecx),%edi
801039da:	8b 73 18             	mov    0x18(%ebx),%esi
801039dd:	b9 13 00 00 00       	mov    $0x13,%ecx
801039e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801039e4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801039e6:	8b 40 18             	mov    0x18(%eax),%eax
801039e9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
801039f0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801039f4:	85 c0                	test   %eax,%eax
801039f6:	74 13                	je     80103a0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801039f8:	83 ec 0c             	sub    $0xc,%esp
801039fb:	50                   	push   %eax
801039fc:	e8 ef d3 ff ff       	call   80100df0 <filedup>
80103a01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a04:	83 c4 10             	add    $0x10,%esp
80103a07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103a0b:	83 c6 01             	add    $0x1,%esi
80103a0e:	83 fe 10             	cmp    $0x10,%esi
80103a11:	75 dd                	jne    801039f0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103a13:	83 ec 0c             	sub    $0xc,%esp
80103a16:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103a1c:	e8 2f dc ff ff       	call   80101650 <idup>
80103a21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103a27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a2d:	6a 10                	push   $0x10
80103a2f:	53                   	push   %ebx
80103a30:	50                   	push   %eax
80103a31:	e8 9a 0e 00 00       	call   801048d0 <safestrcpy>
  pid = np->pid;
80103a36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103a39:	c7 04 24 c0 2e 11 80 	movl   $0x80112ec0,(%esp)
80103a40:	e8 8b 0b 00 00       	call   801045d0 <acquire>
  np->state = RUNNABLE;
80103a45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103a4c:	c7 04 24 c0 2e 11 80 	movl   $0x80112ec0,(%esp)
80103a53:	e8 48 0c 00 00       	call   801046a0 <release>
  return pid;
80103a58:	83 c4 10             	add    $0x10,%esp
}
80103a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a5e:	89 d8                	mov    %ebx,%eax
80103a60:	5b                   	pop    %ebx
80103a61:	5e                   	pop    %esi
80103a62:	5f                   	pop    %edi
80103a63:	5d                   	pop    %ebp
80103a64:	c3                   	ret    
    return -1;
80103a65:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103a6a:	eb ef                	jmp    80103a5b <fork+0xdb>
    kfree(np->kstack);
80103a6c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103a6f:	83 ec 0c             	sub    $0xc,%esp
80103a72:	ff 73 08             	pushl  0x8(%ebx)
80103a75:	e8 96 e8 ff ff       	call   80102310 <kfree>
    np->kstack = 0;
80103a7a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103a81:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103a88:	83 c4 10             	add    $0x10,%esp
80103a8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103a90:	eb c9                	jmp    80103a5b <fork+0xdb>
80103a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103aa0 <scheduler>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	57                   	push   %edi
80103aa4:	56                   	push   %esi
80103aa5:	53                   	push   %ebx
80103aa6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103aa9:	e8 92 fc ff ff       	call   80103740 <mycpu>
80103aae:	8d 78 04             	lea    0x4(%eax),%edi
80103ab1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ab3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103aba:	00 00 00 
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ac0:	fb                   	sti    
    acquire(&ptable.lock);
80103ac1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ac4:	bb f8 2e 11 80       	mov    $0x80112ef8,%ebx
    acquire(&ptable.lock);
80103ac9:	68 c0 2e 11 80       	push   $0x80112ec0
80103ace:	e8 fd 0a 00 00       	call   801045d0 <acquire>
80103ad3:	83 c4 10             	add    $0x10,%esp
80103ad6:	8d 76 00             	lea    0x0(%esi),%esi
80103ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103ae0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ae4:	75 33                	jne    80103b19 <scheduler+0x79>
      switchuvm(p);
80103ae6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ae9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103aef:	53                   	push   %ebx
80103af0:	e8 fb 2f 00 00       	call   80106af0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103af5:	58                   	pop    %eax
80103af6:	5a                   	pop    %edx
80103af7:	ff 73 1c             	pushl  0x1c(%ebx)
80103afa:	57                   	push   %edi
      p->state = RUNNING;
80103afb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103b02:	e8 24 0e 00 00       	call   8010492b <swtch>
      switchkvm();
80103b07:	e8 c4 2f 00 00       	call   80106ad0 <switchkvm>
      c->proc = 0;
80103b0c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b13:	00 00 00 
80103b16:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b19:	83 c3 7c             	add    $0x7c,%ebx
80103b1c:	81 fb f8 4d 11 80    	cmp    $0x80114df8,%ebx
80103b22:	72 bc                	jb     80103ae0 <scheduler+0x40>
    release(&ptable.lock);
80103b24:	83 ec 0c             	sub    $0xc,%esp
80103b27:	68 c0 2e 11 80       	push   $0x80112ec0
80103b2c:	e8 6f 0b 00 00       	call   801046a0 <release>
    sti();
80103b31:	83 c4 10             	add    $0x10,%esp
80103b34:	eb 8a                	jmp    80103ac0 <scheduler+0x20>
80103b36:	8d 76 00             	lea    0x0(%esi),%esi
80103b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b40 <sched>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
80103b44:	53                   	push   %ebx
  pushcli();
80103b45:	e8 b6 09 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103b4a:	e8 f1 fb ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103b4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b55:	e8 e6 09 00 00       	call   80104540 <popcli>
  if(!holding(&ptable.lock))
80103b5a:	83 ec 0c             	sub    $0xc,%esp
80103b5d:	68 c0 2e 11 80       	push   $0x80112ec0
80103b62:	e8 39 0a 00 00       	call   801045a0 <holding>
80103b67:	83 c4 10             	add    $0x10,%esp
80103b6a:	85 c0                	test   %eax,%eax
80103b6c:	74 4f                	je     80103bbd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103b6e:	e8 cd fb ff ff       	call   80103740 <mycpu>
80103b73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b7a:	75 68                	jne    80103be4 <sched+0xa4>
  if(p->state == RUNNING)
80103b7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b80:	74 55                	je     80103bd7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b82:	9c                   	pushf  
80103b83:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b84:	f6 c4 02             	test   $0x2,%ah
80103b87:	75 41                	jne    80103bca <sched+0x8a>
  intena = mycpu()->intena;
80103b89:	e8 b2 fb ff ff       	call   80103740 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b8e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103b91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b97:	e8 a4 fb ff ff       	call   80103740 <mycpu>
80103b9c:	83 ec 08             	sub    $0x8,%esp
80103b9f:	ff 70 04             	pushl  0x4(%eax)
80103ba2:	53                   	push   %ebx
80103ba3:	e8 83 0d 00 00       	call   8010492b <swtch>
  mycpu()->intena = intena;
80103ba8:	e8 93 fb ff ff       	call   80103740 <mycpu>
}
80103bad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103bb0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bb9:	5b                   	pop    %ebx
80103bba:	5e                   	pop    %esi
80103bbb:	5d                   	pop    %ebp
80103bbc:	c3                   	ret    
    panic("sched ptable.lock");
80103bbd:	83 ec 0c             	sub    $0xc,%esp
80103bc0:	68 50 77 10 80       	push   $0x80107750
80103bc5:	e8 c6 c7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103bca:	83 ec 0c             	sub    $0xc,%esp
80103bcd:	68 7c 77 10 80       	push   $0x8010777c
80103bd2:	e8 b9 c7 ff ff       	call   80100390 <panic>
    panic("sched running");
80103bd7:	83 ec 0c             	sub    $0xc,%esp
80103bda:	68 6e 77 10 80       	push   $0x8010776e
80103bdf:	e8 ac c7 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103be4:	83 ec 0c             	sub    $0xc,%esp
80103be7:	68 62 77 10 80       	push   $0x80107762
80103bec:	e8 9f c7 ff ff       	call   80100390 <panic>
80103bf1:	eb 0d                	jmp    80103c00 <exit>
80103bf3:	90                   	nop
80103bf4:	90                   	nop
80103bf5:	90                   	nop
80103bf6:	90                   	nop
80103bf7:	90                   	nop
80103bf8:	90                   	nop
80103bf9:	90                   	nop
80103bfa:	90                   	nop
80103bfb:	90                   	nop
80103bfc:	90                   	nop
80103bfd:	90                   	nop
80103bfe:	90                   	nop
80103bff:	90                   	nop

80103c00 <exit>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	57                   	push   %edi
80103c04:	56                   	push   %esi
80103c05:	53                   	push   %ebx
80103c06:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103c09:	e8 f2 08 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103c0e:	e8 2d fb ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103c13:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c19:	e8 22 09 00 00       	call   80104540 <popcli>
  if(curproc == initproc)
80103c1e:	39 35 bc a5 10 80    	cmp    %esi,0x8010a5bc
80103c24:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c27:	8d 7e 68             	lea    0x68(%esi),%edi
80103c2a:	0f 84 e7 00 00 00    	je     80103d17 <exit+0x117>
    if(curproc->ofile[fd]){
80103c30:	8b 03                	mov    (%ebx),%eax
80103c32:	85 c0                	test   %eax,%eax
80103c34:	74 12                	je     80103c48 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c36:	83 ec 0c             	sub    $0xc,%esp
80103c39:	50                   	push   %eax
80103c3a:	e8 01 d2 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103c3f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c45:	83 c4 10             	add    $0x10,%esp
80103c48:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103c4b:	39 fb                	cmp    %edi,%ebx
80103c4d:	75 e1                	jne    80103c30 <exit+0x30>
  begin_op();
80103c4f:	e8 4c ef ff ff       	call   80102ba0 <begin_op>
  iput(curproc->cwd);
80103c54:	83 ec 0c             	sub    $0xc,%esp
80103c57:	ff 76 68             	pushl  0x68(%esi)
80103c5a:	e8 51 db ff ff       	call   801017b0 <iput>
  end_op();
80103c5f:	e8 ac ef ff ff       	call   80102c10 <end_op>
  curproc->cwd = 0;
80103c64:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103c6b:	c7 04 24 c0 2e 11 80 	movl   $0x80112ec0,(%esp)
80103c72:	e8 59 09 00 00       	call   801045d0 <acquire>
  wakeup1(curproc->parent);
80103c77:	8b 56 14             	mov    0x14(%esi),%edx
80103c7a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c7d:	b8 f8 2e 11 80       	mov    $0x80112ef8,%eax
80103c82:	eb 0e                	jmp    80103c92 <exit+0x92>
80103c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c88:	83 c0 7c             	add    $0x7c,%eax
80103c8b:	3d f8 4d 11 80       	cmp    $0x80114df8,%eax
80103c90:	73 1c                	jae    80103cae <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103c92:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c96:	75 f0                	jne    80103c88 <exit+0x88>
80103c98:	3b 50 20             	cmp    0x20(%eax),%edx
80103c9b:	75 eb                	jne    80103c88 <exit+0x88>
      p->state = RUNNABLE;
80103c9d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ca4:	83 c0 7c             	add    $0x7c,%eax
80103ca7:	3d f8 4d 11 80       	cmp    $0x80114df8,%eax
80103cac:	72 e4                	jb     80103c92 <exit+0x92>
      p->parent = initproc;
80103cae:	8b 0d bc a5 10 80    	mov    0x8010a5bc,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb4:	ba f8 2e 11 80       	mov    $0x80112ef8,%edx
80103cb9:	eb 10                	jmp    80103ccb <exit+0xcb>
80103cbb:	90                   	nop
80103cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cc0:	83 c2 7c             	add    $0x7c,%edx
80103cc3:	81 fa f8 4d 11 80    	cmp    $0x80114df8,%edx
80103cc9:	73 33                	jae    80103cfe <exit+0xfe>
    if(p->parent == curproc){
80103ccb:	39 72 14             	cmp    %esi,0x14(%edx)
80103cce:	75 f0                	jne    80103cc0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103cd0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103cd4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103cd7:	75 e7                	jne    80103cc0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cd9:	b8 f8 2e 11 80       	mov    $0x80112ef8,%eax
80103cde:	eb 0a                	jmp    80103cea <exit+0xea>
80103ce0:	83 c0 7c             	add    $0x7c,%eax
80103ce3:	3d f8 4d 11 80       	cmp    $0x80114df8,%eax
80103ce8:	73 d6                	jae    80103cc0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103cea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cee:	75 f0                	jne    80103ce0 <exit+0xe0>
80103cf0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103cf3:	75 eb                	jne    80103ce0 <exit+0xe0>
      p->state = RUNNABLE;
80103cf5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103cfc:	eb e2                	jmp    80103ce0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103cfe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d05:	e8 36 fe ff ff       	call   80103b40 <sched>
  panic("zombie exit");
80103d0a:	83 ec 0c             	sub    $0xc,%esp
80103d0d:	68 9d 77 10 80       	push   $0x8010779d
80103d12:	e8 79 c6 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103d17:	83 ec 0c             	sub    $0xc,%esp
80103d1a:	68 90 77 10 80       	push   $0x80107790
80103d1f:	e8 6c c6 ff ff       	call   80100390 <panic>
80103d24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d30 <yield>:
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	53                   	push   %ebx
80103d34:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d37:	68 c0 2e 11 80       	push   $0x80112ec0
80103d3c:	e8 8f 08 00 00       	call   801045d0 <acquire>
  pushcli();
80103d41:	e8 ba 07 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103d46:	e8 f5 f9 ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103d4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d51:	e8 ea 07 00 00       	call   80104540 <popcli>
  myproc()->state = RUNNABLE;
80103d56:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103d5d:	e8 de fd ff ff       	call   80103b40 <sched>
  release(&ptable.lock);
80103d62:	c7 04 24 c0 2e 11 80 	movl   $0x80112ec0,(%esp)
80103d69:	e8 32 09 00 00       	call   801046a0 <release>
}
80103d6e:	83 c4 10             	add    $0x10,%esp
80103d71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d74:	c9                   	leave  
80103d75:	c3                   	ret    
80103d76:	8d 76 00             	lea    0x0(%esi),%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d80 <sleep>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 0c             	sub    $0xc,%esp
80103d89:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103d8f:	e8 6c 07 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103d94:	e8 a7 f9 ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103d99:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d9f:	e8 9c 07 00 00       	call   80104540 <popcli>
  if(p == 0)
80103da4:	85 db                	test   %ebx,%ebx
80103da6:	0f 84 87 00 00 00    	je     80103e33 <sleep+0xb3>
  if(lk == 0)
80103dac:	85 f6                	test   %esi,%esi
80103dae:	74 76                	je     80103e26 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103db0:	81 fe c0 2e 11 80    	cmp    $0x80112ec0,%esi
80103db6:	74 50                	je     80103e08 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103db8:	83 ec 0c             	sub    $0xc,%esp
80103dbb:	68 c0 2e 11 80       	push   $0x80112ec0
80103dc0:	e8 0b 08 00 00       	call   801045d0 <acquire>
    release(lk);
80103dc5:	89 34 24             	mov    %esi,(%esp)
80103dc8:	e8 d3 08 00 00       	call   801046a0 <release>
  p->chan = chan;
80103dcd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103dd0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103dd7:	e8 64 fd ff ff       	call   80103b40 <sched>
  p->chan = 0;
80103ddc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103de3:	c7 04 24 c0 2e 11 80 	movl   $0x80112ec0,(%esp)
80103dea:	e8 b1 08 00 00       	call   801046a0 <release>
    acquire(lk);
80103def:	89 75 08             	mov    %esi,0x8(%ebp)
80103df2:	83 c4 10             	add    $0x10,%esp
}
80103df5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103df8:	5b                   	pop    %ebx
80103df9:	5e                   	pop    %esi
80103dfa:	5f                   	pop    %edi
80103dfb:	5d                   	pop    %ebp
    acquire(lk);
80103dfc:	e9 cf 07 00 00       	jmp    801045d0 <acquire>
80103e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103e08:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e0b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e12:	e8 29 fd ff ff       	call   80103b40 <sched>
  p->chan = 0;
80103e17:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e21:	5b                   	pop    %ebx
80103e22:	5e                   	pop    %esi
80103e23:	5f                   	pop    %edi
80103e24:	5d                   	pop    %ebp
80103e25:	c3                   	ret    
    panic("sleep without lk");
80103e26:	83 ec 0c             	sub    $0xc,%esp
80103e29:	68 af 77 10 80       	push   $0x801077af
80103e2e:	e8 5d c5 ff ff       	call   80100390 <panic>
    panic("sleep");
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	68 a9 77 10 80       	push   $0x801077a9
80103e3b:	e8 50 c5 ff ff       	call   80100390 <panic>

80103e40 <wait>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	56                   	push   %esi
80103e44:	53                   	push   %ebx
  pushcli();
80103e45:	e8 b6 06 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103e4a:	e8 f1 f8 ff ff       	call   80103740 <mycpu>
  p = c->proc;
80103e4f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e55:	e8 e6 06 00 00       	call   80104540 <popcli>
  acquire(&ptable.lock);
80103e5a:	83 ec 0c             	sub    $0xc,%esp
80103e5d:	68 c0 2e 11 80       	push   $0x80112ec0
80103e62:	e8 69 07 00 00       	call   801045d0 <acquire>
80103e67:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103e6a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e6c:	bb f8 2e 11 80       	mov    $0x80112ef8,%ebx
80103e71:	eb 10                	jmp    80103e83 <wait+0x43>
80103e73:	90                   	nop
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e78:	83 c3 7c             	add    $0x7c,%ebx
80103e7b:	81 fb f8 4d 11 80    	cmp    $0x80114df8,%ebx
80103e81:	73 1b                	jae    80103e9e <wait+0x5e>
      if(p->parent != curproc)
80103e83:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e86:	75 f0                	jne    80103e78 <wait+0x38>
      if(p->state == ZOMBIE){
80103e88:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e8c:	74 32                	je     80103ec0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103e91:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e96:	81 fb f8 4d 11 80    	cmp    $0x80114df8,%ebx
80103e9c:	72 e5                	jb     80103e83 <wait+0x43>
    if(!havekids || curproc->killed){
80103e9e:	85 c0                	test   %eax,%eax
80103ea0:	74 74                	je     80103f16 <wait+0xd6>
80103ea2:	8b 46 24             	mov    0x24(%esi),%eax
80103ea5:	85 c0                	test   %eax,%eax
80103ea7:	75 6d                	jne    80103f16 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103ea9:	83 ec 08             	sub    $0x8,%esp
80103eac:	68 c0 2e 11 80       	push   $0x80112ec0
80103eb1:	56                   	push   %esi
80103eb2:	e8 c9 fe ff ff       	call   80103d80 <sleep>
    havekids = 0;
80103eb7:	83 c4 10             	add    $0x10,%esp
80103eba:	eb ae                	jmp    80103e6a <wait+0x2a>
80103ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103ec0:	83 ec 0c             	sub    $0xc,%esp
80103ec3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103ec6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103ec9:	e8 42 e4 ff ff       	call   80102310 <kfree>
        freevm(p->pgdir);
80103ece:	5a                   	pop    %edx
80103ecf:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103ed2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ed9:	e8 c2 2f 00 00       	call   80106ea0 <freevm>
        release(&ptable.lock);
80103ede:	c7 04 24 c0 2e 11 80 	movl   $0x80112ec0,(%esp)
        p->pid = 0;
80103ee5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103eec:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103ef3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ef7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103efe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f05:	e8 96 07 00 00       	call   801046a0 <release>
        return pid;
80103f0a:	83 c4 10             	add    $0x10,%esp
}
80103f0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f10:	89 f0                	mov    %esi,%eax
80103f12:	5b                   	pop    %ebx
80103f13:	5e                   	pop    %esi
80103f14:	5d                   	pop    %ebp
80103f15:	c3                   	ret    
      release(&ptable.lock);
80103f16:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f19:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103f1e:	68 c0 2e 11 80       	push   $0x80112ec0
80103f23:	e8 78 07 00 00       	call   801046a0 <release>
      return -1;
80103f28:	83 c4 10             	add    $0x10,%esp
80103f2b:	eb e0                	jmp    80103f0d <wait+0xcd>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi

80103f30 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	53                   	push   %ebx
80103f34:	83 ec 10             	sub    $0x10,%esp
80103f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f3a:	68 c0 2e 11 80       	push   $0x80112ec0
80103f3f:	e8 8c 06 00 00       	call   801045d0 <acquire>
80103f44:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f47:	b8 f8 2e 11 80       	mov    $0x80112ef8,%eax
80103f4c:	eb 0c                	jmp    80103f5a <wakeup+0x2a>
80103f4e:	66 90                	xchg   %ax,%ax
80103f50:	83 c0 7c             	add    $0x7c,%eax
80103f53:	3d f8 4d 11 80       	cmp    $0x80114df8,%eax
80103f58:	73 1c                	jae    80103f76 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103f5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f5e:	75 f0                	jne    80103f50 <wakeup+0x20>
80103f60:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f63:	75 eb                	jne    80103f50 <wakeup+0x20>
      p->state = RUNNABLE;
80103f65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f6c:	83 c0 7c             	add    $0x7c,%eax
80103f6f:	3d f8 4d 11 80       	cmp    $0x80114df8,%eax
80103f74:	72 e4                	jb     80103f5a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80103f76:	c7 45 08 c0 2e 11 80 	movl   $0x80112ec0,0x8(%ebp)
}
80103f7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f80:	c9                   	leave  
  release(&ptable.lock);
80103f81:	e9 1a 07 00 00       	jmp    801046a0 <release>
80103f86:	8d 76 00             	lea    0x0(%esi),%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	53                   	push   %ebx
80103f94:	83 ec 10             	sub    $0x10,%esp
80103f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f9a:	68 c0 2e 11 80       	push   $0x80112ec0
80103f9f:	e8 2c 06 00 00       	call   801045d0 <acquire>
80103fa4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa7:	b8 f8 2e 11 80       	mov    $0x80112ef8,%eax
80103fac:	eb 0c                	jmp    80103fba <kill+0x2a>
80103fae:	66 90                	xchg   %ax,%ax
80103fb0:	83 c0 7c             	add    $0x7c,%eax
80103fb3:	3d f8 4d 11 80       	cmp    $0x80114df8,%eax
80103fb8:	73 36                	jae    80103ff0 <kill+0x60>
    if(p->pid == pid){
80103fba:	39 58 10             	cmp    %ebx,0x10(%eax)
80103fbd:	75 f1                	jne    80103fb0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103fbf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103fc3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103fca:	75 07                	jne    80103fd3 <kill+0x43>
        p->state = RUNNABLE;
80103fcc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80103fd3:	83 ec 0c             	sub    $0xc,%esp
80103fd6:	68 c0 2e 11 80       	push   $0x80112ec0
80103fdb:	e8 c0 06 00 00       	call   801046a0 <release>
      return 0;
80103fe0:	83 c4 10             	add    $0x10,%esp
80103fe3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fe8:	c9                   	leave  
80103fe9:	c3                   	ret    
80103fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103ff0:	83 ec 0c             	sub    $0xc,%esp
80103ff3:	68 c0 2e 11 80       	push   $0x80112ec0
80103ff8:	e8 a3 06 00 00       	call   801046a0 <release>
  return -1;
80103ffd:	83 c4 10             	add    $0x10,%esp
80104000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104005:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104008:	c9                   	leave  
80104009:	c3                   	ret    
8010400a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104010 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	57                   	push   %edi
80104014:	56                   	push   %esi
80104015:	53                   	push   %ebx
80104016:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104019:	bb f8 2e 11 80       	mov    $0x80112ef8,%ebx
{
8010401e:	83 ec 3c             	sub    $0x3c,%esp
80104021:	eb 24                	jmp    80104047 <procdump+0x37>
80104023:	90                   	nop
80104024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104028:	83 ec 0c             	sub    $0xc,%esp
8010402b:	68 83 7c 10 80       	push   $0x80107c83
80104030:	e8 2b c6 ff ff       	call   80100660 <cprintf>
80104035:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104038:	83 c3 7c             	add    $0x7c,%ebx
8010403b:	81 fb f8 4d 11 80    	cmp    $0x80114df8,%ebx
80104041:	0f 83 81 00 00 00    	jae    801040c8 <procdump+0xb8>
    if(p->state == UNUSED)
80104047:	8b 43 0c             	mov    0xc(%ebx),%eax
8010404a:	85 c0                	test   %eax,%eax
8010404c:	74 ea                	je     80104038 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010404e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104051:	ba c0 77 10 80       	mov    $0x801077c0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104056:	77 11                	ja     80104069 <procdump+0x59>
80104058:	8b 14 85 64 79 10 80 	mov    -0x7fef869c(,%eax,4),%edx
      state = "???";
8010405f:	b8 c0 77 10 80       	mov    $0x801077c0,%eax
80104064:	85 d2                	test   %edx,%edx
80104066:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104069:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010406c:	50                   	push   %eax
8010406d:	52                   	push   %edx
8010406e:	ff 73 10             	pushl  0x10(%ebx)
80104071:	68 c4 77 10 80       	push   $0x801077c4
80104076:	e8 e5 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010407b:	83 c4 10             	add    $0x10,%esp
8010407e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104082:	75 a4                	jne    80104028 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104084:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104087:	83 ec 08             	sub    $0x8,%esp
8010408a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010408d:	50                   	push   %eax
8010408e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104091:	8b 40 0c             	mov    0xc(%eax),%eax
80104094:	83 c0 08             	add    $0x8,%eax
80104097:	50                   	push   %eax
80104098:	e8 13 04 00 00       	call   801044b0 <getcallerpcs>
8010409d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801040a0:	8b 17                	mov    (%edi),%edx
801040a2:	85 d2                	test   %edx,%edx
801040a4:	74 82                	je     80104028 <procdump+0x18>
        cprintf(" %p", pc[i]);
801040a6:	83 ec 08             	sub    $0x8,%esp
801040a9:	83 c7 04             	add    $0x4,%edi
801040ac:	52                   	push   %edx
801040ad:	68 01 72 10 80       	push   $0x80107201
801040b2:	e8 a9 c5 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801040b7:	83 c4 10             	add    $0x10,%esp
801040ba:	39 fe                	cmp    %edi,%esi
801040bc:	75 e2                	jne    801040a0 <procdump+0x90>
801040be:	e9 65 ff ff ff       	jmp    80104028 <procdump+0x18>
801040c3:	90                   	nop
801040c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801040c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040cb:	5b                   	pop    %ebx
801040cc:	5e                   	pop    %esi
801040cd:	5f                   	pop    %edi
801040ce:	5d                   	pop    %ebp
801040cf:	c3                   	ret    

801040d0 <recursionLock>:

void
recursionLock(struct spinlock *lock, int n)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
801040d5:	8b 75 08             	mov    0x8(%ebp),%esi
801040d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801040db:	eb 12                	jmp    801040ef <recursionLock+0x1f>
801040dd:	8d 76 00             	lea    0x0(%esi),%esi
  cprintf("here: %d\n", n);
  if (n == 5) {
    return;
  }
  acquire(lock);
801040e0:	83 ec 0c             	sub    $0xc,%esp
  n++;
801040e3:	83 c3 01             	add    $0x1,%ebx
  acquire(lock);
801040e6:	56                   	push   %esi
801040e7:	e8 e4 04 00 00       	call   801045d0 <acquire>
  n++;
801040ec:	83 c4 10             	add    $0x10,%esp
  cprintf("here: %d\n", n);
801040ef:	83 ec 08             	sub    $0x8,%esp
801040f2:	53                   	push   %ebx
801040f3:	68 cd 77 10 80       	push   $0x801077cd
801040f8:	e8 63 c5 ff ff       	call   80100660 <cprintf>
  if (n == 5) {
801040fd:	83 c4 10             	add    $0x10,%esp
80104100:	83 fb 05             	cmp    $0x5,%ebx
80104103:	75 db                	jne    801040e0 <recursionLock+0x10>
  recursionLock(lock, n);
}
80104105:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104108:	5b                   	pop    %ebx
80104109:	5e                   	pop    %esi
8010410a:	5d                   	pop    %ebp
8010410b:	c3                   	ret    
8010410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104110 <reentrant>:

void
reentrant()
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	56                   	push   %esi
80104114:	53                   	push   %ebx
  struct spinlock lock;
  initlock(&lock, "reentrant");
80104115:	8d 5d c0             	lea    -0x40(%ebp),%ebx
{
80104118:	83 ec 48             	sub    $0x48,%esp
  initlock(&lock, "reentrant");
8010411b:	68 d7 77 10 80       	push   $0x801077d7
80104120:	53                   	push   %ebx
80104121:	e8 4a 03 00 00       	call   80104470 <initlock>
  pushcli();
80104126:	e8 d5 03 00 00       	call   80104500 <pushcli>
  c = mycpu();
8010412b:	e8 10 f6 ff ff       	call   80103740 <mycpu>
  p = c->proc;
80104130:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104136:	e8 05 04 00 00       	call   80104540 <popcli>
  setLockPid(&lock, myproc()->pid);
8010413b:	58                   	pop    %eax
8010413c:	5a                   	pop    %edx
8010413d:	ff 76 10             	pushl  0x10(%esi)
80104140:	53                   	push   %ebx
80104141:	e8 5a 03 00 00       	call   801044a0 <setLockPid>
  recursionLock(&lock, 0);
80104146:	59                   	pop    %ecx
80104147:	5e                   	pop    %esi
80104148:	6a 00                	push   $0x0
8010414a:	53                   	push   %ebx
8010414b:	e8 80 ff ff ff       	call   801040d0 <recursionLock>
  release(&lock);
80104150:	89 1c 24             	mov    %ebx,(%esp)
80104153:	e8 48 05 00 00       	call   801046a0 <release>
}
80104158:	83 c4 10             	add    $0x10,%esp
8010415b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010415e:	5b                   	pop    %ebx
8010415f:	5e                   	pop    %esi
80104160:	5d                   	pop    %ebp
80104161:	c3                   	ret    
80104162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104170 <barrier>:

void
barrier(int number)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	57                   	push   %edi
80104174:	56                   	push   %esi
80104175:	53                   	push   %ebx
80104176:	83 ec 10             	sub    $0x10,%esp
80104179:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("number is: %d waitCount is %d\n", number, bar.waitCount);
8010417c:	ff 35 70 4e 11 80    	pushl  0x80114e70
80104182:	53                   	push   %ebx
80104183:	68 84 78 10 80       	push   $0x80107884
80104188:	e8 d3 c4 ff ff       	call   80100660 <cprintf>
  if(bar.waitCount < number)
8010418d:	83 c4 10             	add    $0x10,%esp
80104190:	39 1d 70 4e 11 80    	cmp    %ebx,0x80114e70
80104196:	7c 08                	jl     801041a0 <barrier+0x30>
      cprintf("process with pid = %d is sleeped at %d\n", myproc()->pid, ticks);
      sleep(&(bar.sl), &(bar.sl));
      release(&(bar.sl));
    }
  }
}
80104198:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010419b:	5b                   	pop    %ebx
8010419c:	5e                   	pop    %esi
8010419d:	5f                   	pop    %edi
8010419e:	5d                   	pop    %ebp
8010419f:	c3                   	ret    
    acquire(&(bar.countLock));
801041a0:	83 ec 0c             	sub    $0xc,%esp
801041a3:	68 38 4e 11 80       	push   $0x80114e38
801041a8:	e8 23 04 00 00       	call   801045d0 <acquire>
    cprintf("process with pid = %d arrived at %d\n", myproc()->pid, ticks);
801041ad:	8b 3d c0 56 11 80    	mov    0x801156c0,%edi
    bar.waitCount++;
801041b3:	83 05 70 4e 11 80 01 	addl   $0x1,0x80114e70
  pushcli();
801041ba:	e8 41 03 00 00       	call   80104500 <pushcli>
  c = mycpu();
801041bf:	e8 7c f5 ff ff       	call   80103740 <mycpu>
  p = c->proc;
801041c4:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041ca:	e8 71 03 00 00       	call   80104540 <popcli>
    cprintf("process with pid = %d arrived at %d\n", myproc()->pid, ticks);
801041cf:	83 c4 0c             	add    $0xc,%esp
801041d2:	57                   	push   %edi
801041d3:	ff 76 10             	pushl  0x10(%esi)
801041d6:	68 a4 78 10 80       	push   $0x801078a4
801041db:	e8 80 c4 ff ff       	call   80100660 <cprintf>
    cprintf("%d processes are waiting before barrier\n", bar.waitCount);
801041e0:	5e                   	pop    %esi
801041e1:	5f                   	pop    %edi
801041e2:	ff 35 70 4e 11 80    	pushl  0x80114e70
801041e8:	68 cc 78 10 80       	push   $0x801078cc
801041ed:	e8 6e c4 ff ff       	call   80100660 <cprintf>
    cprintf("%d process not arrived yet\n",number - bar.waitCount);
801041f2:	58                   	pop    %eax
801041f3:	89 d8                	mov    %ebx,%eax
801041f5:	2b 05 70 4e 11 80    	sub    0x80114e70,%eax
801041fb:	5a                   	pop    %edx
801041fc:	50                   	push   %eax
801041fd:	68 e1 77 10 80       	push   $0x801077e1
80104202:	e8 59 c4 ff ff       	call   80100660 <cprintf>
    if (bar.waitCount == number) {
80104207:	83 c4 10             	add    $0x10,%esp
8010420a:	39 1d 70 4e 11 80    	cmp    %ebx,0x80114e70
80104210:	74 6e                	je     80104280 <barrier+0x110>
    } else if (bar.waitCount < number) {
80104212:	7d 84                	jge    80104198 <barrier+0x28>
      release(&(bar.countLock));
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	68 38 4e 11 80       	push   $0x80114e38
8010421c:	e8 7f 04 00 00       	call   801046a0 <release>
      acquire(&(bar.sl));
80104221:	c7 04 24 00 4e 11 80 	movl   $0x80114e00,(%esp)
80104228:	e8 a3 03 00 00       	call   801045d0 <acquire>
      cprintf("process with pid = %d is sleeped at %d\n", myproc()->pid, ticks);
8010422d:	8b 35 c0 56 11 80    	mov    0x801156c0,%esi
  pushcli();
80104233:	e8 c8 02 00 00       	call   80104500 <pushcli>
  c = mycpu();
80104238:	e8 03 f5 ff ff       	call   80103740 <mycpu>
  p = c->proc;
8010423d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104243:	e8 f8 02 00 00       	call   80104540 <popcli>
      cprintf("process with pid = %d is sleeped at %d\n", myproc()->pid, ticks);
80104248:	83 c4 0c             	add    $0xc,%esp
8010424b:	56                   	push   %esi
8010424c:	ff 73 10             	pushl  0x10(%ebx)
8010424f:	68 3c 79 10 80       	push   $0x8010793c
80104254:	e8 07 c4 ff ff       	call   80100660 <cprintf>
      sleep(&(bar.sl), &(bar.sl));
80104259:	58                   	pop    %eax
8010425a:	5a                   	pop    %edx
8010425b:	68 00 4e 11 80       	push   $0x80114e00
80104260:	68 00 4e 11 80       	push   $0x80114e00
80104265:	e8 16 fb ff ff       	call   80103d80 <sleep>
      release(&(bar.sl));
8010426a:	83 c4 10             	add    $0x10,%esp
8010426d:	c7 45 08 00 4e 11 80 	movl   $0x80114e00,0x8(%ebp)
}
80104274:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104277:	5b                   	pop    %ebx
80104278:	5e                   	pop    %esi
80104279:	5f                   	pop    %edi
8010427a:	5d                   	pop    %ebp
      release(&(bar.sl));
8010427b:	e9 20 04 00 00       	jmp    801046a0 <release>
  pushcli();
80104280:	e8 7b 02 00 00       	call   80104500 <pushcli>
  c = mycpu();
80104285:	e8 b6 f4 ff ff       	call   80103740 <mycpu>
  p = c->proc;
8010428a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104290:	e8 ab 02 00 00       	call   80104540 <popcli>
      cprintf("wich proc %d\n", myproc()->pid);
80104295:	83 ec 08             	sub    $0x8,%esp
80104298:	ff 73 10             	pushl  0x10(%ebx)
8010429b:	68 fd 77 10 80       	push   $0x801077fd
801042a0:	e8 bb c3 ff ff       	call   80100660 <cprintf>
      cprintf("all processes arrived\n");
801042a5:	c7 04 24 0b 78 10 80 	movl   $0x8010780b,(%esp)
801042ac:	e8 af c3 ff ff       	call   80100660 <cprintf>
      wakeup(&(bar.sl));
801042b1:	c7 04 24 00 4e 11 80 	movl   $0x80114e00,(%esp)
801042b8:	e8 73 fc ff ff       	call   80103f30 <wakeup>
      cprintf("wakeup at %d\n", ticks);
801042bd:	59                   	pop    %ecx
801042be:	5b                   	pop    %ebx
801042bf:	ff 35 c0 56 11 80    	pushl  0x801156c0
801042c5:	68 22 78 10 80       	push   $0x80107822
801042ca:	e8 91 c3 ff ff       	call   80100660 <cprintf>
      cprintf("all processes passed the barrier-------------------------------\n");
801042cf:	c7 04 24 f8 78 10 80 	movl   $0x801078f8,(%esp)
801042d6:	e8 85 c3 ff ff       	call   80100660 <cprintf>
      bar.waitCount = 0;
801042db:	c7 05 70 4e 11 80 00 	movl   $0x0,0x80114e70
801042e2:	00 00 00 
      release(&(bar.countLock));
801042e5:	83 c4 10             	add    $0x10,%esp
801042e8:	c7 45 08 38 4e 11 80 	movl   $0x80114e38,0x8(%ebp)
801042ef:	eb 83                	jmp    80104274 <barrier+0x104>
801042f1:	eb 0d                	jmp    80104300 <init_barrier>
801042f3:	90                   	nop
801042f4:	90                   	nop
801042f5:	90                   	nop
801042f6:	90                   	nop
801042f7:	90                   	nop
801042f8:	90                   	nop
801042f9:	90                   	nop
801042fa:	90                   	nop
801042fb:	90                   	nop
801042fc:	90                   	nop
801042fd:	90                   	nop
801042fe:	90                   	nop
801042ff:	90                   	nop

80104300 <init_barrier>:

void init_barrier()
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	83 ec 14             	sub    $0x14,%esp
  acquire(&(bar.countLock));
80104306:	68 38 4e 11 80       	push   $0x80114e38
8010430b:	e8 c0 02 00 00       	call   801045d0 <acquire>
  bar.waitCount = 0;
  bar.isBarInited = 1;
  release(&(bar.countLock));
80104310:	c7 04 24 38 4e 11 80 	movl   $0x80114e38,(%esp)
  bar.waitCount = 0;
80104317:	c7 05 70 4e 11 80 00 	movl   $0x0,0x80114e70
8010431e:	00 00 00 
  bar.isBarInited = 1;
80104321:	c7 05 74 4e 11 80 01 	movl   $0x1,0x80114e74
80104328:	00 00 00 
  release(&(bar.countLock));
8010432b:	e8 70 03 00 00       	call   801046a0 <release>
80104330:	83 c4 10             	add    $0x10,%esp
80104333:	c9                   	leave  
80104334:	c3                   	ret    
80104335:	66 90                	xchg   %ax,%ax
80104337:	66 90                	xchg   %ax,%ax
80104339:	66 90                	xchg   %ax,%ax
8010433b:	66 90                	xchg   %ax,%ax
8010433d:	66 90                	xchg   %ax,%ax
8010433f:	90                   	nop

80104340 <initsleeplock>:
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 0c             	sub    $0xc,%esp
80104347:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010434a:	68 7c 79 10 80       	push   $0x8010797c
8010434f:	8d 43 04             	lea    0x4(%ebx),%eax
80104352:	50                   	push   %eax
80104353:	e8 18 01 00 00       	call   80104470 <initlock>
80104358:	8b 45 0c             	mov    0xc(%ebp),%eax
8010435b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104361:	83 c4 10             	add    $0x10,%esp
80104364:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
8010436b:	89 43 3c             	mov    %eax,0x3c(%ebx)
8010436e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104371:	c9                   	leave  
80104372:	c3                   	ret    
80104373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104380 <acquiresleep>:
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104388:	83 ec 0c             	sub    $0xc,%esp
8010438b:	8d 73 04             	lea    0x4(%ebx),%esi
8010438e:	56                   	push   %esi
8010438f:	e8 3c 02 00 00       	call   801045d0 <acquire>
80104394:	8b 13                	mov    (%ebx),%edx
80104396:	83 c4 10             	add    $0x10,%esp
80104399:	85 d2                	test   %edx,%edx
8010439b:	74 16                	je     801043b3 <acquiresleep+0x33>
8010439d:	8d 76 00             	lea    0x0(%esi),%esi
801043a0:	83 ec 08             	sub    $0x8,%esp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
801043a5:	e8 d6 f9 ff ff       	call   80103d80 <sleep>
801043aa:	8b 03                	mov    (%ebx),%eax
801043ac:	83 c4 10             	add    $0x10,%esp
801043af:	85 c0                	test   %eax,%eax
801043b1:	75 ed                	jne    801043a0 <acquiresleep+0x20>
801043b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
801043b9:	e8 22 f4 ff ff       	call   801037e0 <myproc>
801043be:	8b 40 10             	mov    0x10(%eax),%eax
801043c1:	89 43 40             	mov    %eax,0x40(%ebx)
801043c4:	89 75 08             	mov    %esi,0x8(%ebp)
801043c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043ca:	5b                   	pop    %ebx
801043cb:	5e                   	pop    %esi
801043cc:	5d                   	pop    %ebp
801043cd:	e9 ce 02 00 00       	jmp    801046a0 <release>
801043d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <releasesleep>:
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	56                   	push   %esi
801043e4:	53                   	push   %ebx
801043e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	8d 73 04             	lea    0x4(%ebx),%esi
801043ee:	56                   	push   %esi
801043ef:	e8 dc 01 00 00       	call   801045d0 <acquire>
801043f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801043fa:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
80104401:	89 1c 24             	mov    %ebx,(%esp)
80104404:	e8 27 fb ff ff       	call   80103f30 <wakeup>
80104409:	89 75 08             	mov    %esi,0x8(%ebp)
8010440c:	83 c4 10             	add    $0x10,%esp
8010440f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104412:	5b                   	pop    %ebx
80104413:	5e                   	pop    %esi
80104414:	5d                   	pop    %ebp
80104415:	e9 86 02 00 00       	jmp    801046a0 <release>
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104420 <holdingsleep>:
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	57                   	push   %edi
80104424:	56                   	push   %esi
80104425:	53                   	push   %ebx
80104426:	31 ff                	xor    %edi,%edi
80104428:	83 ec 18             	sub    $0x18,%esp
8010442b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010442e:	8d 73 04             	lea    0x4(%ebx),%esi
80104431:	56                   	push   %esi
80104432:	e8 99 01 00 00       	call   801045d0 <acquire>
80104437:	8b 03                	mov    (%ebx),%eax
80104439:	83 c4 10             	add    $0x10,%esp
8010443c:	85 c0                	test   %eax,%eax
8010443e:	74 13                	je     80104453 <holdingsleep+0x33>
80104440:	8b 5b 40             	mov    0x40(%ebx),%ebx
80104443:	e8 98 f3 ff ff       	call   801037e0 <myproc>
80104448:	39 58 10             	cmp    %ebx,0x10(%eax)
8010444b:	0f 94 c0             	sete   %al
8010444e:	0f b6 c0             	movzbl %al,%eax
80104451:	89 c7                	mov    %eax,%edi
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	56                   	push   %esi
80104457:	e8 44 02 00 00       	call   801046a0 <release>
8010445c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010445f:	89 f8                	mov    %edi,%eax
80104461:	5b                   	pop    %ebx
80104462:	5e                   	pop    %esi
80104463:	5f                   	pop    %edi
80104464:	5d                   	pop    %ebp
80104465:	c3                   	ret    
80104466:	66 90                	xchg   %ax,%ax
80104468:	66 90                	xchg   %ax,%ax
8010446a:	66 90                	xchg   %ax,%ax
8010446c:	66 90                	xchg   %ax,%ax
8010446e:	66 90                	xchg   %ax,%ax

80104470 <initlock>:
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	8b 45 08             	mov    0x8(%ebp),%eax
80104476:	8b 55 0c             	mov    0xc(%ebp),%edx
80104479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010447f:	89 50 04             	mov    %edx,0x4(%eax)
80104482:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
80104489:	c7 40 34 ff ff ff ff 	movl   $0xffffffff,0x34(%eax)
80104490:	5d                   	pop    %ebp
80104491:	c3                   	ret    
80104492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044a0 <setLockPid>:
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	8b 45 08             	mov    0x8(%ebp),%eax
801044a6:	8b 55 0c             	mov    0xc(%ebp),%edx
801044a9:	89 50 34             	mov    %edx,0x34(%eax)
801044ac:	5d                   	pop    %ebp
801044ad:	c3                   	ret    
801044ae:	66 90                	xchg   %ax,%ax

801044b0 <getcallerpcs>:
801044b0:	55                   	push   %ebp
801044b1:	31 d2                	xor    %edx,%edx
801044b3:	89 e5                	mov    %esp,%ebp
801044b5:	53                   	push   %ebx
801044b6:	8b 45 08             	mov    0x8(%ebp),%eax
801044b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801044bc:	83 e8 08             	sub    $0x8,%eax
801044bf:	90                   	nop
801044c0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801044c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044cc:	77 1a                	ja     801044e8 <getcallerpcs+0x38>
801044ce:	8b 58 04             	mov    0x4(%eax),%ebx
801044d1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
801044d4:	83 c2 01             	add    $0x1,%edx
801044d7:	8b 00                	mov    (%eax),%eax
801044d9:	83 fa 0a             	cmp    $0xa,%edx
801044dc:	75 e2                	jne    801044c0 <getcallerpcs+0x10>
801044de:	5b                   	pop    %ebx
801044df:	5d                   	pop    %ebp
801044e0:	c3                   	ret    
801044e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044e8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801044eb:	83 c1 28             	add    $0x28,%ecx
801044ee:	66 90                	xchg   %ax,%ax
801044f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801044f6:	83 c0 04             	add    $0x4,%eax
801044f9:	39 c1                	cmp    %eax,%ecx
801044fb:	75 f3                	jne    801044f0 <getcallerpcs+0x40>
801044fd:	5b                   	pop    %ebx
801044fe:	5d                   	pop    %ebp
801044ff:	c3                   	ret    

80104500 <pushcli>:
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	53                   	push   %ebx
80104504:	83 ec 04             	sub    $0x4,%esp
80104507:	9c                   	pushf  
80104508:	5b                   	pop    %ebx
80104509:	fa                   	cli    
8010450a:	e8 31 f2 ff ff       	call   80103740 <mycpu>
8010450f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104515:	85 c0                	test   %eax,%eax
80104517:	75 11                	jne    8010452a <pushcli+0x2a>
80104519:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010451f:	e8 1c f2 ff ff       	call   80103740 <mycpu>
80104524:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
8010452a:	e8 11 f2 ff ff       	call   80103740 <mycpu>
8010452f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
80104536:	83 c4 04             	add    $0x4,%esp
80104539:	5b                   	pop    %ebx
8010453a:	5d                   	pop    %ebp
8010453b:	c3                   	ret    
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104540 <popcli>:
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	83 ec 08             	sub    $0x8,%esp
80104546:	9c                   	pushf  
80104547:	58                   	pop    %eax
80104548:	f6 c4 02             	test   $0x2,%ah
8010454b:	75 35                	jne    80104582 <popcli+0x42>
8010454d:	e8 ee f1 ff ff       	call   80103740 <mycpu>
80104552:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104559:	78 34                	js     8010458f <popcli+0x4f>
8010455b:	e8 e0 f1 ff ff       	call   80103740 <mycpu>
80104560:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104566:	85 d2                	test   %edx,%edx
80104568:	74 06                	je     80104570 <popcli+0x30>
8010456a:	c9                   	leave  
8010456b:	c3                   	ret    
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104570:	e8 cb f1 ff ff       	call   80103740 <mycpu>
80104575:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010457b:	85 c0                	test   %eax,%eax
8010457d:	74 eb                	je     8010456a <popcli+0x2a>
8010457f:	fb                   	sti    
80104580:	c9                   	leave  
80104581:	c3                   	ret    
80104582:	83 ec 0c             	sub    $0xc,%esp
80104585:	68 87 79 10 80       	push   $0x80107987
8010458a:	e8 01 be ff ff       	call   80100390 <panic>
8010458f:	83 ec 0c             	sub    $0xc,%esp
80104592:	68 9e 79 10 80       	push   $0x8010799e
80104597:	e8 f4 bd ff ff       	call   80100390 <panic>
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045a0 <holding>:
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	56                   	push   %esi
801045a4:	53                   	push   %ebx
801045a5:	8b 75 08             	mov    0x8(%ebp),%esi
801045a8:	31 db                	xor    %ebx,%ebx
801045aa:	e8 51 ff ff ff       	call   80104500 <pushcli>
801045af:	8b 06                	mov    (%esi),%eax
801045b1:	85 c0                	test   %eax,%eax
801045b3:	74 10                	je     801045c5 <holding+0x25>
801045b5:	8b 5e 08             	mov    0x8(%esi),%ebx
801045b8:	e8 83 f1 ff ff       	call   80103740 <mycpu>
801045bd:	39 c3                	cmp    %eax,%ebx
801045bf:	0f 94 c3             	sete   %bl
801045c2:	0f b6 db             	movzbl %bl,%ebx
801045c5:	e8 76 ff ff ff       	call   80104540 <popcli>
801045ca:	89 d8                	mov    %ebx,%eax
801045cc:	5b                   	pop    %ebx
801045cd:	5e                   	pop    %esi
801045ce:	5d                   	pop    %ebp
801045cf:	c3                   	ret    

801045d0 <acquire>:
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
801045d7:	e8 24 ff ff ff       	call   80104500 <pushcli>
801045dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045df:	83 ec 0c             	sub    $0xc,%esp
801045e2:	53                   	push   %ebx
801045e3:	e8 b8 ff ff ff       	call   801045a0 <holding>
801045e8:	83 c4 10             	add    $0x10,%esp
801045eb:	85 c0                	test   %eax,%eax
801045ed:	ba 01 00 00 00       	mov    $0x1,%edx
801045f2:	74 0f                	je     80104603 <acquire+0x33>
801045f4:	e9 7f 00 00 00       	jmp    80104678 <acquire+0xa8>
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104600:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104603:	89 d0                	mov    %edx,%eax
80104605:	f0 87 03             	lock xchg %eax,(%ebx)
80104608:	85 c0                	test   %eax,%eax
8010460a:	75 f4                	jne    80104600 <acquire+0x30>
8010460c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
80104611:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104614:	e8 27 f1 ff ff       	call   80103740 <mycpu>
80104619:	31 d2                	xor    %edx,%edx
8010461b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
8010461e:	89 43 08             	mov    %eax,0x8(%ebx)
80104621:	89 e8                	mov    %ebp,%eax
80104623:	90                   	nop
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104628:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010462e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104634:	77 1a                	ja     80104650 <acquire+0x80>
80104636:	8b 58 04             	mov    0x4(%eax),%ebx
80104639:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
8010463c:	83 c2 01             	add    $0x1,%edx
8010463f:	8b 00                	mov    (%eax),%eax
80104641:	83 fa 0a             	cmp    $0xa,%edx
80104644:	75 e2                	jne    80104628 <acquire+0x58>
80104646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104649:	c9                   	leave  
8010464a:	c3                   	ret    
8010464b:	90                   	nop
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104650:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104653:	83 c1 28             	add    $0x28,%ecx
80104656:	8d 76 00             	lea    0x0(%esi),%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104660:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104666:	83 c0 04             	add    $0x4,%eax
80104669:	39 c8                	cmp    %ecx,%eax
8010466b:	75 f3                	jne    80104660 <acquire+0x90>
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104670:	c9                   	leave  
80104671:	c3                   	ret    
80104672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104678:	e8 63 f1 ff ff       	call   801037e0 <myproc>
8010467d:	8b 4b 34             	mov    0x34(%ebx),%ecx
80104680:	39 48 10             	cmp    %ecx,0x10(%eax)
80104683:	75 07                	jne    8010468c <acquire+0xbc>
80104685:	e8 b6 fe ff ff       	call   80104540 <popcli>
8010468a:	eb 80                	jmp    8010460c <acquire+0x3c>
8010468c:	83 ec 0c             	sub    $0xc,%esp
8010468f:	68 a5 79 10 80       	push   $0x801079a5
80104694:	e8 f7 bc ff ff       	call   80100390 <panic>
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046a0 <release>:
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 10             	sub    $0x10,%esp
801046a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046aa:	53                   	push   %ebx
801046ab:	e8 f0 fe ff ff       	call   801045a0 <holding>
801046b0:	83 c4 10             	add    $0x10,%esp
801046b3:	85 c0                	test   %eax,%eax
801046b5:	74 22                	je     801046d9 <release+0x39>
801046b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
801046be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
801046c5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
801046ca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801046d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d3:	c9                   	leave  
801046d4:	e9 67 fe ff ff       	jmp    80104540 <popcli>
801046d9:	83 ec 0c             	sub    $0xc,%esp
801046dc:	68 ad 79 10 80       	push   $0x801079ad
801046e1:	e8 aa bc ff ff       	call   80100390 <panic>
801046e6:	66 90                	xchg   %ax,%ax
801046e8:	66 90                	xchg   %ax,%ax
801046ea:	66 90                	xchg   %ax,%ax
801046ec:	66 90                	xchg   %ax,%ax
801046ee:	66 90                	xchg   %ax,%ax

801046f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	53                   	push   %ebx
801046f5:	8b 55 08             	mov    0x8(%ebp),%edx
801046f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801046fb:	f6 c2 03             	test   $0x3,%dl
801046fe:	75 05                	jne    80104705 <memset+0x15>
80104700:	f6 c1 03             	test   $0x3,%cl
80104703:	74 13                	je     80104718 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104705:	89 d7                	mov    %edx,%edi
80104707:	8b 45 0c             	mov    0xc(%ebp),%eax
8010470a:	fc                   	cld    
8010470b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010470d:	5b                   	pop    %ebx
8010470e:	89 d0                	mov    %edx,%eax
80104710:	5f                   	pop    %edi
80104711:	5d                   	pop    %ebp
80104712:	c3                   	ret    
80104713:	90                   	nop
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104718:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010471c:	c1 e9 02             	shr    $0x2,%ecx
8010471f:	89 f8                	mov    %edi,%eax
80104721:	89 fb                	mov    %edi,%ebx
80104723:	c1 e0 18             	shl    $0x18,%eax
80104726:	c1 e3 10             	shl    $0x10,%ebx
80104729:	09 d8                	or     %ebx,%eax
8010472b:	09 f8                	or     %edi,%eax
8010472d:	c1 e7 08             	shl    $0x8,%edi
80104730:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104732:	89 d7                	mov    %edx,%edi
80104734:	fc                   	cld    
80104735:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104737:	5b                   	pop    %ebx
80104738:	89 d0                	mov    %edx,%eax
8010473a:	5f                   	pop    %edi
8010473b:	5d                   	pop    %ebp
8010473c:	c3                   	ret    
8010473d:	8d 76 00             	lea    0x0(%esi),%esi

80104740 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	57                   	push   %edi
80104744:	56                   	push   %esi
80104745:	53                   	push   %ebx
80104746:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104749:	8b 75 08             	mov    0x8(%ebp),%esi
8010474c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010474f:	85 db                	test   %ebx,%ebx
80104751:	74 29                	je     8010477c <memcmp+0x3c>
    if(*s1 != *s2)
80104753:	0f b6 16             	movzbl (%esi),%edx
80104756:	0f b6 0f             	movzbl (%edi),%ecx
80104759:	38 d1                	cmp    %dl,%cl
8010475b:	75 2b                	jne    80104788 <memcmp+0x48>
8010475d:	b8 01 00 00 00       	mov    $0x1,%eax
80104762:	eb 14                	jmp    80104778 <memcmp+0x38>
80104764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104768:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010476c:	83 c0 01             	add    $0x1,%eax
8010476f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104774:	38 ca                	cmp    %cl,%dl
80104776:	75 10                	jne    80104788 <memcmp+0x48>
  while(n-- > 0){
80104778:	39 d8                	cmp    %ebx,%eax
8010477a:	75 ec                	jne    80104768 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010477c:	5b                   	pop    %ebx
  return 0;
8010477d:	31 c0                	xor    %eax,%eax
}
8010477f:	5e                   	pop    %esi
80104780:	5f                   	pop    %edi
80104781:	5d                   	pop    %ebp
80104782:	c3                   	ret    
80104783:	90                   	nop
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104788:	0f b6 c2             	movzbl %dl,%eax
}
8010478b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010478c:	29 c8                	sub    %ecx,%eax
}
8010478e:	5e                   	pop    %esi
8010478f:	5f                   	pop    %edi
80104790:	5d                   	pop    %ebp
80104791:	c3                   	ret    
80104792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	56                   	push   %esi
801047a4:	53                   	push   %ebx
801047a5:	8b 45 08             	mov    0x8(%ebp),%eax
801047a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801047ab:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047ae:	39 c3                	cmp    %eax,%ebx
801047b0:	73 26                	jae    801047d8 <memmove+0x38>
801047b2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801047b5:	39 c8                	cmp    %ecx,%eax
801047b7:	73 1f                	jae    801047d8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801047b9:	85 f6                	test   %esi,%esi
801047bb:	8d 56 ff             	lea    -0x1(%esi),%edx
801047be:	74 0f                	je     801047cf <memmove+0x2f>
      *--d = *--s;
801047c0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801047c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801047c7:	83 ea 01             	sub    $0x1,%edx
801047ca:	83 fa ff             	cmp    $0xffffffff,%edx
801047cd:	75 f1                	jne    801047c0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047cf:	5b                   	pop    %ebx
801047d0:	5e                   	pop    %esi
801047d1:	5d                   	pop    %ebp
801047d2:	c3                   	ret    
801047d3:	90                   	nop
801047d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801047d8:	31 d2                	xor    %edx,%edx
801047da:	85 f6                	test   %esi,%esi
801047dc:	74 f1                	je     801047cf <memmove+0x2f>
801047de:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801047e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801047e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801047e7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801047ea:	39 d6                	cmp    %edx,%esi
801047ec:	75 f2                	jne    801047e0 <memmove+0x40>
}
801047ee:	5b                   	pop    %ebx
801047ef:	5e                   	pop    %esi
801047f0:	5d                   	pop    %ebp
801047f1:	c3                   	ret    
801047f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104803:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104804:	eb 9a                	jmp    801047a0 <memmove>
80104806:	8d 76 00             	lea    0x0(%esi),%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104810 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	8b 7d 10             	mov    0x10(%ebp),%edi
80104818:	53                   	push   %ebx
80104819:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010481c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010481f:	85 ff                	test   %edi,%edi
80104821:	74 2f                	je     80104852 <strncmp+0x42>
80104823:	0f b6 01             	movzbl (%ecx),%eax
80104826:	0f b6 1e             	movzbl (%esi),%ebx
80104829:	84 c0                	test   %al,%al
8010482b:	74 37                	je     80104864 <strncmp+0x54>
8010482d:	38 c3                	cmp    %al,%bl
8010482f:	75 33                	jne    80104864 <strncmp+0x54>
80104831:	01 f7                	add    %esi,%edi
80104833:	eb 13                	jmp    80104848 <strncmp+0x38>
80104835:	8d 76 00             	lea    0x0(%esi),%esi
80104838:	0f b6 01             	movzbl (%ecx),%eax
8010483b:	84 c0                	test   %al,%al
8010483d:	74 21                	je     80104860 <strncmp+0x50>
8010483f:	0f b6 1a             	movzbl (%edx),%ebx
80104842:	89 d6                	mov    %edx,%esi
80104844:	38 d8                	cmp    %bl,%al
80104846:	75 1c                	jne    80104864 <strncmp+0x54>
    n--, p++, q++;
80104848:	8d 56 01             	lea    0x1(%esi),%edx
8010484b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010484e:	39 fa                	cmp    %edi,%edx
80104850:	75 e6                	jne    80104838 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104852:	5b                   	pop    %ebx
    return 0;
80104853:	31 c0                	xor    %eax,%eax
}
80104855:	5e                   	pop    %esi
80104856:	5f                   	pop    %edi
80104857:	5d                   	pop    %ebp
80104858:	c3                   	ret    
80104859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104860:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104864:	29 d8                	sub    %ebx,%eax
}
80104866:	5b                   	pop    %ebx
80104867:	5e                   	pop    %esi
80104868:	5f                   	pop    %edi
80104869:	5d                   	pop    %ebp
8010486a:	c3                   	ret    
8010486b:	90                   	nop
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104870 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	8b 45 08             	mov    0x8(%ebp),%eax
80104878:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010487b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010487e:	89 c2                	mov    %eax,%edx
80104880:	eb 19                	jmp    8010489b <strncpy+0x2b>
80104882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104888:	83 c3 01             	add    $0x1,%ebx
8010488b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010488f:	83 c2 01             	add    $0x1,%edx
80104892:	84 c9                	test   %cl,%cl
80104894:	88 4a ff             	mov    %cl,-0x1(%edx)
80104897:	74 09                	je     801048a2 <strncpy+0x32>
80104899:	89 f1                	mov    %esi,%ecx
8010489b:	85 c9                	test   %ecx,%ecx
8010489d:	8d 71 ff             	lea    -0x1(%ecx),%esi
801048a0:	7f e6                	jg     80104888 <strncpy+0x18>
    ;
  while(n-- > 0)
801048a2:	31 c9                	xor    %ecx,%ecx
801048a4:	85 f6                	test   %esi,%esi
801048a6:	7e 17                	jle    801048bf <strncpy+0x4f>
801048a8:	90                   	nop
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801048b0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801048b4:	89 f3                	mov    %esi,%ebx
801048b6:	83 c1 01             	add    $0x1,%ecx
801048b9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801048bb:	85 db                	test   %ebx,%ebx
801048bd:	7f f1                	jg     801048b0 <strncpy+0x40>
  return os;
}
801048bf:	5b                   	pop    %ebx
801048c0:	5e                   	pop    %esi
801048c1:	5d                   	pop    %ebp
801048c2:	c3                   	ret    
801048c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
801048d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048d8:	8b 45 08             	mov    0x8(%ebp),%eax
801048db:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801048de:	85 c9                	test   %ecx,%ecx
801048e0:	7e 26                	jle    80104908 <safestrcpy+0x38>
801048e2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801048e6:	89 c1                	mov    %eax,%ecx
801048e8:	eb 17                	jmp    80104901 <safestrcpy+0x31>
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048f0:	83 c2 01             	add    $0x1,%edx
801048f3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801048f7:	83 c1 01             	add    $0x1,%ecx
801048fa:	84 db                	test   %bl,%bl
801048fc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801048ff:	74 04                	je     80104905 <safestrcpy+0x35>
80104901:	39 f2                	cmp    %esi,%edx
80104903:	75 eb                	jne    801048f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104905:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104908:	5b                   	pop    %ebx
80104909:	5e                   	pop    %esi
8010490a:	5d                   	pop    %ebp
8010490b:	c3                   	ret    
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104910 <strlen>:

int
strlen(const char *s)
{
80104910:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104911:	31 c0                	xor    %eax,%eax
{
80104913:	89 e5                	mov    %esp,%ebp
80104915:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104918:	80 3a 00             	cmpb   $0x0,(%edx)
8010491b:	74 0c                	je     80104929 <strlen+0x19>
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
80104920:	83 c0 01             	add    $0x1,%eax
80104923:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104927:	75 f7                	jne    80104920 <strlen+0x10>
    ;
  return n;
}
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    

8010492b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010492b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010492f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104933:	55                   	push   %ebp
  pushl %ebx
80104934:	53                   	push   %ebx
  pushl %esi
80104935:	56                   	push   %esi
  pushl %edi
80104936:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104937:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104939:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010493b:	5f                   	pop    %edi
  popl %esi
8010493c:	5e                   	pop    %esi
  popl %ebx
8010493d:	5b                   	pop    %ebx
  popl %ebp
8010493e:	5d                   	pop    %ebp
  ret
8010493f:	c3                   	ret    

80104940 <fetchint>:
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 04             	sub    $0x4,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010494a:	e8 91 ee ff ff       	call   801037e0 <myproc>
8010494f:	8b 00                	mov    (%eax),%eax
80104951:	39 d8                	cmp    %ebx,%eax
80104953:	76 1b                	jbe    80104970 <fetchint+0x30>
80104955:	8d 53 04             	lea    0x4(%ebx),%edx
80104958:	39 d0                	cmp    %edx,%eax
8010495a:	72 14                	jb     80104970 <fetchint+0x30>
8010495c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010495f:	8b 13                	mov    (%ebx),%edx
80104961:	89 10                	mov    %edx,(%eax)
80104963:	31 c0                	xor    %eax,%eax
80104965:	83 c4 04             	add    $0x4,%esp
80104968:	5b                   	pop    %ebx
80104969:	5d                   	pop    %ebp
8010496a:	c3                   	ret    
8010496b:	90                   	nop
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104975:	eb ee                	jmp    80104965 <fetchint+0x25>
80104977:	89 f6                	mov    %esi,%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <fetchstr>:
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 04             	sub    $0x4,%esp
80104987:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010498a:	e8 51 ee ff ff       	call   801037e0 <myproc>
8010498f:	39 18                	cmp    %ebx,(%eax)
80104991:	76 29                	jbe    801049bc <fetchstr+0x3c>
80104993:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104996:	89 da                	mov    %ebx,%edx
80104998:	89 19                	mov    %ebx,(%ecx)
8010499a:	8b 00                	mov    (%eax),%eax
8010499c:	39 c3                	cmp    %eax,%ebx
8010499e:	73 1c                	jae    801049bc <fetchstr+0x3c>
801049a0:	80 3b 00             	cmpb   $0x0,(%ebx)
801049a3:	75 10                	jne    801049b5 <fetchstr+0x35>
801049a5:	eb 39                	jmp    801049e0 <fetchstr+0x60>
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049b0:	80 3a 00             	cmpb   $0x0,(%edx)
801049b3:	74 1b                	je     801049d0 <fetchstr+0x50>
801049b5:	83 c2 01             	add    $0x1,%edx
801049b8:	39 d0                	cmp    %edx,%eax
801049ba:	77 f4                	ja     801049b0 <fetchstr+0x30>
801049bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049c1:	83 c4 04             	add    $0x4,%esp
801049c4:	5b                   	pop    %ebx
801049c5:	5d                   	pop    %ebp
801049c6:	c3                   	ret    
801049c7:	89 f6                	mov    %esi,%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049d0:	83 c4 04             	add    $0x4,%esp
801049d3:	89 d0                	mov    %edx,%eax
801049d5:	29 d8                	sub    %ebx,%eax
801049d7:	5b                   	pop    %ebx
801049d8:	5d                   	pop    %ebp
801049d9:	c3                   	ret    
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049e0:	31 c0                	xor    %eax,%eax
801049e2:	eb dd                	jmp    801049c1 <fetchstr+0x41>
801049e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049f0 <argint>:
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	e8 e6 ed ff ff       	call   801037e0 <myproc>
801049fa:	8b 40 18             	mov    0x18(%eax),%eax
801049fd:	8b 55 08             	mov    0x8(%ebp),%edx
80104a00:	8b 40 44             	mov    0x44(%eax),%eax
80104a03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
80104a06:	e8 d5 ed ff ff       	call   801037e0 <myproc>
80104a0b:	8b 00                	mov    (%eax),%eax
80104a0d:	8d 73 04             	lea    0x4(%ebx),%esi
80104a10:	39 c6                	cmp    %eax,%esi
80104a12:	73 1c                	jae    80104a30 <argint+0x40>
80104a14:	8d 53 08             	lea    0x8(%ebx),%edx
80104a17:	39 d0                	cmp    %edx,%eax
80104a19:	72 15                	jb     80104a30 <argint+0x40>
80104a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a1e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a21:	89 10                	mov    %edx,(%eax)
80104a23:	31 c0                	xor    %eax,%eax
80104a25:	5b                   	pop    %ebx
80104a26:	5e                   	pop    %esi
80104a27:	5d                   	pop    %ebp
80104a28:	c3                   	ret    
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a35:	eb ee                	jmp    80104a25 <argint+0x35>
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <argptr>:
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
80104a45:	83 ec 10             	sub    $0x10,%esp
80104a48:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a4b:	e8 90 ed ff ff       	call   801037e0 <myproc>
80104a50:	89 c6                	mov    %eax,%esi
80104a52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a55:	83 ec 08             	sub    $0x8,%esp
80104a58:	50                   	push   %eax
80104a59:	ff 75 08             	pushl  0x8(%ebp)
80104a5c:	e8 8f ff ff ff       	call   801049f0 <argint>
80104a61:	83 c4 10             	add    $0x10,%esp
80104a64:	85 c0                	test   %eax,%eax
80104a66:	78 28                	js     80104a90 <argptr+0x50>
80104a68:	85 db                	test   %ebx,%ebx
80104a6a:	78 24                	js     80104a90 <argptr+0x50>
80104a6c:	8b 16                	mov    (%esi),%edx
80104a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a71:	39 c2                	cmp    %eax,%edx
80104a73:	76 1b                	jbe    80104a90 <argptr+0x50>
80104a75:	01 c3                	add    %eax,%ebx
80104a77:	39 da                	cmp    %ebx,%edx
80104a79:	72 15                	jb     80104a90 <argptr+0x50>
80104a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a7e:	89 02                	mov    %eax,(%edx)
80104a80:	31 c0                	xor    %eax,%eax
80104a82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a85:	5b                   	pop    %ebx
80104a86:	5e                   	pop    %esi
80104a87:	5d                   	pop    %ebp
80104a88:	c3                   	ret    
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a95:	eb eb                	jmp    80104a82 <argptr+0x42>
80104a97:	89 f6                	mov    %esi,%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <argstr>:
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	83 ec 20             	sub    $0x20,%esp
80104aa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aa9:	50                   	push   %eax
80104aaa:	ff 75 08             	pushl  0x8(%ebp)
80104aad:	e8 3e ff ff ff       	call   801049f0 <argint>
80104ab2:	83 c4 10             	add    $0x10,%esp
80104ab5:	85 c0                	test   %eax,%eax
80104ab7:	78 17                	js     80104ad0 <argstr+0x30>
80104ab9:	83 ec 08             	sub    $0x8,%esp
80104abc:	ff 75 0c             	pushl  0xc(%ebp)
80104abf:	ff 75 f4             	pushl  -0xc(%ebp)
80104ac2:	e8 b9 fe ff ff       	call   80104980 <fetchstr>
80104ac7:	83 c4 10             	add    $0x10,%esp
80104aca:	c9                   	leave  
80104acb:	c3                   	ret    
80104acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ad5:	c9                   	leave  
80104ad6:	c3                   	ret    
80104ad7:	89 f6                	mov    %esi,%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ae0 <syscall>:
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
80104ae7:	e8 f4 ec ff ff       	call   801037e0 <myproc>
80104aec:	89 c3                	mov    %eax,%ebx
80104aee:	8b 40 18             	mov    0x18(%eax),%eax
80104af1:	8b 40 1c             	mov    0x1c(%eax),%eax
80104af4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104af7:	83 fa 17             	cmp    $0x17,%edx
80104afa:	77 1c                	ja     80104b18 <syscall+0x38>
80104afc:	8b 14 85 e0 79 10 80 	mov    -0x7fef8620(,%eax,4),%edx
80104b03:	85 d2                	test   %edx,%edx
80104b05:	74 11                	je     80104b18 <syscall+0x38>
80104b07:	ff d2                	call   *%edx
80104b09:	8b 53 18             	mov    0x18(%ebx),%edx
80104b0c:	89 42 1c             	mov    %eax,0x1c(%edx)
80104b0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b12:	c9                   	leave  
80104b13:	c3                   	ret    
80104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b18:	50                   	push   %eax
80104b19:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104b1c:	50                   	push   %eax
80104b1d:	ff 73 10             	pushl  0x10(%ebx)
80104b20:	68 b5 79 10 80       	push   $0x801079b5
80104b25:	e8 36 bb ff ff       	call   80100660 <cprintf>
80104b2a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b2d:	83 c4 10             	add    $0x10,%esp
80104b30:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104b37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b3a:	c9                   	leave  
80104b3b:	c3                   	ret    
80104b3c:	66 90                	xchg   %ax,%ax
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <create>:
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	53                   	push   %ebx
80104b46:	8d 75 da             	lea    -0x26(%ebp),%esi
80104b49:	83 ec 34             	sub    $0x34,%esp
80104b4c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b52:	56                   	push   %esi
80104b53:	50                   	push   %eax
80104b54:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b57:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80104b5a:	e8 a1 d3 ff ff       	call   80101f00 <nameiparent>
80104b5f:	83 c4 10             	add    $0x10,%esp
80104b62:	85 c0                	test   %eax,%eax
80104b64:	0f 84 46 01 00 00    	je     80104cb0 <create+0x170>
80104b6a:	83 ec 0c             	sub    $0xc,%esp
80104b6d:	89 c3                	mov    %eax,%ebx
80104b6f:	50                   	push   %eax
80104b70:	e8 0b cb ff ff       	call   80101680 <ilock>
80104b75:	83 c4 0c             	add    $0xc,%esp
80104b78:	6a 00                	push   $0x0
80104b7a:	56                   	push   %esi
80104b7b:	53                   	push   %ebx
80104b7c:	e8 2f d0 ff ff       	call   80101bb0 <dirlookup>
80104b81:	83 c4 10             	add    $0x10,%esp
80104b84:	85 c0                	test   %eax,%eax
80104b86:	89 c7                	mov    %eax,%edi
80104b88:	74 36                	je     80104bc0 <create+0x80>
80104b8a:	83 ec 0c             	sub    $0xc,%esp
80104b8d:	53                   	push   %ebx
80104b8e:	e8 7d cd ff ff       	call   80101910 <iunlockput>
80104b93:	89 3c 24             	mov    %edi,(%esp)
80104b96:	e8 e5 ca ff ff       	call   80101680 <ilock>
80104b9b:	83 c4 10             	add    $0x10,%esp
80104b9e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ba3:	0f 85 97 00 00 00    	jne    80104c40 <create+0x100>
80104ba9:	66 83 7f 54 02       	cmpw   $0x2,0x54(%edi)
80104bae:	0f 85 8c 00 00 00    	jne    80104c40 <create+0x100>
80104bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bb7:	89 f8                	mov    %edi,%eax
80104bb9:	5b                   	pop    %ebx
80104bba:	5e                   	pop    %esi
80104bbb:	5f                   	pop    %edi
80104bbc:	5d                   	pop    %ebp
80104bbd:	c3                   	ret    
80104bbe:	66 90                	xchg   %ax,%ax
80104bc0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bc4:	83 ec 08             	sub    $0x8,%esp
80104bc7:	50                   	push   %eax
80104bc8:	ff 33                	pushl  (%ebx)
80104bca:	e8 41 c9 ff ff       	call   80101510 <ialloc>
80104bcf:	83 c4 10             	add    $0x10,%esp
80104bd2:	85 c0                	test   %eax,%eax
80104bd4:	89 c7                	mov    %eax,%edi
80104bd6:	0f 84 e8 00 00 00    	je     80104cc4 <create+0x184>
80104bdc:	83 ec 0c             	sub    $0xc,%esp
80104bdf:	50                   	push   %eax
80104be0:	e8 9b ca ff ff       	call   80101680 <ilock>
80104be5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104be9:	66 89 47 56          	mov    %ax,0x56(%edi)
80104bed:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104bf1:	66 89 47 58          	mov    %ax,0x58(%edi)
80104bf5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bfa:	66 89 47 5a          	mov    %ax,0x5a(%edi)
80104bfe:	89 3c 24             	mov    %edi,(%esp)
80104c01:	e8 ca c9 ff ff       	call   801015d0 <iupdate>
80104c06:	83 c4 10             	add    $0x10,%esp
80104c09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104c0e:	74 50                	je     80104c60 <create+0x120>
80104c10:	83 ec 04             	sub    $0x4,%esp
80104c13:	ff 77 04             	pushl  0x4(%edi)
80104c16:	56                   	push   %esi
80104c17:	53                   	push   %ebx
80104c18:	e8 03 d2 ff ff       	call   80101e20 <dirlink>
80104c1d:	83 c4 10             	add    $0x10,%esp
80104c20:	85 c0                	test   %eax,%eax
80104c22:	0f 88 8f 00 00 00    	js     80104cb7 <create+0x177>
80104c28:	83 ec 0c             	sub    $0xc,%esp
80104c2b:	53                   	push   %ebx
80104c2c:	e8 df cc ff ff       	call   80101910 <iunlockput>
80104c31:	83 c4 10             	add    $0x10,%esp
80104c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c37:	89 f8                	mov    %edi,%eax
80104c39:	5b                   	pop    %ebx
80104c3a:	5e                   	pop    %esi
80104c3b:	5f                   	pop    %edi
80104c3c:	5d                   	pop    %ebp
80104c3d:	c3                   	ret    
80104c3e:	66 90                	xchg   %ax,%ax
80104c40:	83 ec 0c             	sub    $0xc,%esp
80104c43:	57                   	push   %edi
80104c44:	31 ff                	xor    %edi,%edi
80104c46:	e8 c5 cc ff ff       	call   80101910 <iunlockput>
80104c4b:	83 c4 10             	add    $0x10,%esp
80104c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c51:	89 f8                	mov    %edi,%eax
80104c53:	5b                   	pop    %ebx
80104c54:	5e                   	pop    %esi
80104c55:	5f                   	pop    %edi
80104c56:	5d                   	pop    %ebp
80104c57:	c3                   	ret    
80104c58:	90                   	nop
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c60:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
80104c65:	83 ec 0c             	sub    $0xc,%esp
80104c68:	53                   	push   %ebx
80104c69:	e8 62 c9 ff ff       	call   801015d0 <iupdate>
80104c6e:	83 c4 0c             	add    $0xc,%esp
80104c71:	ff 77 04             	pushl  0x4(%edi)
80104c74:	68 60 7a 10 80       	push   $0x80107a60
80104c79:	57                   	push   %edi
80104c7a:	e8 a1 d1 ff ff       	call   80101e20 <dirlink>
80104c7f:	83 c4 10             	add    $0x10,%esp
80104c82:	85 c0                	test   %eax,%eax
80104c84:	78 1c                	js     80104ca2 <create+0x162>
80104c86:	83 ec 04             	sub    $0x4,%esp
80104c89:	ff 73 04             	pushl  0x4(%ebx)
80104c8c:	68 5f 7a 10 80       	push   $0x80107a5f
80104c91:	57                   	push   %edi
80104c92:	e8 89 d1 ff ff       	call   80101e20 <dirlink>
80104c97:	83 c4 10             	add    $0x10,%esp
80104c9a:	85 c0                	test   %eax,%eax
80104c9c:	0f 89 6e ff ff ff    	jns    80104c10 <create+0xd0>
80104ca2:	83 ec 0c             	sub    $0xc,%esp
80104ca5:	68 53 7a 10 80       	push   $0x80107a53
80104caa:	e8 e1 b6 ff ff       	call   80100390 <panic>
80104caf:	90                   	nop
80104cb0:	31 ff                	xor    %edi,%edi
80104cb2:	e9 fd fe ff ff       	jmp    80104bb4 <create+0x74>
80104cb7:	83 ec 0c             	sub    $0xc,%esp
80104cba:	68 62 7a 10 80       	push   $0x80107a62
80104cbf:	e8 cc b6 ff ff       	call   80100390 <panic>
80104cc4:	83 ec 0c             	sub    $0xc,%esp
80104cc7:	68 44 7a 10 80       	push   $0x80107a44
80104ccc:	e8 bf b6 ff ff       	call   80100390 <panic>
80104cd1:	eb 0d                	jmp    80104ce0 <argfd.constprop.0>
80104cd3:	90                   	nop
80104cd4:	90                   	nop
80104cd5:	90                   	nop
80104cd6:	90                   	nop
80104cd7:	90                   	nop
80104cd8:	90                   	nop
80104cd9:	90                   	nop
80104cda:	90                   	nop
80104cdb:	90                   	nop
80104cdc:	90                   	nop
80104cdd:	90                   	nop
80104cde:	90                   	nop
80104cdf:	90                   	nop

80104ce0 <argfd.constprop.0>:
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
80104ce5:	89 c3                	mov    %eax,%ebx
80104ce7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cea:	89 d6                	mov    %edx,%esi
80104cec:	83 ec 18             	sub    $0x18,%esp
80104cef:	50                   	push   %eax
80104cf0:	6a 00                	push   $0x0
80104cf2:	e8 f9 fc ff ff       	call   801049f0 <argint>
80104cf7:	83 c4 10             	add    $0x10,%esp
80104cfa:	85 c0                	test   %eax,%eax
80104cfc:	78 2a                	js     80104d28 <argfd.constprop.0+0x48>
80104cfe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d02:	77 24                	ja     80104d28 <argfd.constprop.0+0x48>
80104d04:	e8 d7 ea ff ff       	call   801037e0 <myproc>
80104d09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d0c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d10:	85 c0                	test   %eax,%eax
80104d12:	74 14                	je     80104d28 <argfd.constprop.0+0x48>
80104d14:	85 db                	test   %ebx,%ebx
80104d16:	74 02                	je     80104d1a <argfd.constprop.0+0x3a>
80104d18:	89 13                	mov    %edx,(%ebx)
80104d1a:	89 06                	mov    %eax,(%esi)
80104d1c:	31 c0                	xor    %eax,%eax
80104d1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d21:	5b                   	pop    %ebx
80104d22:	5e                   	pop    %esi
80104d23:	5d                   	pop    %ebp
80104d24:	c3                   	ret    
80104d25:	8d 76 00             	lea    0x0(%esi),%esi
80104d28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d2d:	eb ef                	jmp    80104d1e <argfd.constprop.0+0x3e>
80104d2f:	90                   	nop

80104d30 <sys_dup>:
80104d30:	55                   	push   %ebp
80104d31:	31 c0                	xor    %eax,%eax
80104d33:	89 e5                	mov    %esp,%ebp
80104d35:	56                   	push   %esi
80104d36:	53                   	push   %ebx
80104d37:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d3a:	83 ec 10             	sub    $0x10,%esp
80104d3d:	e8 9e ff ff ff       	call   80104ce0 <argfd.constprop.0>
80104d42:	85 c0                	test   %eax,%eax
80104d44:	78 42                	js     80104d88 <sys_dup+0x58>
80104d46:	8b 75 f4             	mov    -0xc(%ebp),%esi
80104d49:	31 db                	xor    %ebx,%ebx
80104d4b:	e8 90 ea ff ff       	call   801037e0 <myproc>
80104d50:	eb 0e                	jmp    80104d60 <sys_dup+0x30>
80104d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d58:	83 c3 01             	add    $0x1,%ebx
80104d5b:	83 fb 10             	cmp    $0x10,%ebx
80104d5e:	74 28                	je     80104d88 <sys_dup+0x58>
80104d60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d64:	85 d2                	test   %edx,%edx
80104d66:	75 f0                	jne    80104d58 <sys_dup+0x28>
80104d68:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
80104d6c:	83 ec 0c             	sub    $0xc,%esp
80104d6f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d72:	e8 79 c0 ff ff       	call   80100df0 <filedup>
80104d77:	83 c4 10             	add    $0x10,%esp
80104d7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d7d:	89 d8                	mov    %ebx,%eax
80104d7f:	5b                   	pop    %ebx
80104d80:	5e                   	pop    %esi
80104d81:	5d                   	pop    %ebp
80104d82:	c3                   	ret    
80104d83:	90                   	nop
80104d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d88:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d90:	89 d8                	mov    %ebx,%eax
80104d92:	5b                   	pop    %ebx
80104d93:	5e                   	pop    %esi
80104d94:	5d                   	pop    %ebp
80104d95:	c3                   	ret    
80104d96:	8d 76 00             	lea    0x0(%esi),%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <sys_read>:
80104da0:	55                   	push   %ebp
80104da1:	31 c0                	xor    %eax,%eax
80104da3:	89 e5                	mov    %esp,%ebp
80104da5:	83 ec 18             	sub    $0x18,%esp
80104da8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dab:	e8 30 ff ff ff       	call   80104ce0 <argfd.constprop.0>
80104db0:	85 c0                	test   %eax,%eax
80104db2:	78 4c                	js     80104e00 <sys_read+0x60>
80104db4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104db7:	83 ec 08             	sub    $0x8,%esp
80104dba:	50                   	push   %eax
80104dbb:	6a 02                	push   $0x2
80104dbd:	e8 2e fc ff ff       	call   801049f0 <argint>
80104dc2:	83 c4 10             	add    $0x10,%esp
80104dc5:	85 c0                	test   %eax,%eax
80104dc7:	78 37                	js     80104e00 <sys_read+0x60>
80104dc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dcc:	83 ec 04             	sub    $0x4,%esp
80104dcf:	ff 75 f0             	pushl  -0x10(%ebp)
80104dd2:	50                   	push   %eax
80104dd3:	6a 01                	push   $0x1
80104dd5:	e8 66 fc ff ff       	call   80104a40 <argptr>
80104dda:	83 c4 10             	add    $0x10,%esp
80104ddd:	85 c0                	test   %eax,%eax
80104ddf:	78 1f                	js     80104e00 <sys_read+0x60>
80104de1:	83 ec 04             	sub    $0x4,%esp
80104de4:	ff 75 f0             	pushl  -0x10(%ebp)
80104de7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dea:	ff 75 ec             	pushl  -0x14(%ebp)
80104ded:	e8 6e c1 ff ff       	call   80100f60 <fileread>
80104df2:	83 c4 10             	add    $0x10,%esp
80104df5:	c9                   	leave  
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e05:	c9                   	leave  
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <sys_write>:
80104e10:	55                   	push   %ebp
80104e11:	31 c0                	xor    %eax,%eax
80104e13:	89 e5                	mov    %esp,%ebp
80104e15:	83 ec 18             	sub    $0x18,%esp
80104e18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e1b:	e8 c0 fe ff ff       	call   80104ce0 <argfd.constprop.0>
80104e20:	85 c0                	test   %eax,%eax
80104e22:	78 4c                	js     80104e70 <sys_write+0x60>
80104e24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e27:	83 ec 08             	sub    $0x8,%esp
80104e2a:	50                   	push   %eax
80104e2b:	6a 02                	push   $0x2
80104e2d:	e8 be fb ff ff       	call   801049f0 <argint>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 37                	js     80104e70 <sys_write+0x60>
80104e39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e3c:	83 ec 04             	sub    $0x4,%esp
80104e3f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e42:	50                   	push   %eax
80104e43:	6a 01                	push   $0x1
80104e45:	e8 f6 fb ff ff       	call   80104a40 <argptr>
80104e4a:	83 c4 10             	add    $0x10,%esp
80104e4d:	85 c0                	test   %eax,%eax
80104e4f:	78 1f                	js     80104e70 <sys_write+0x60>
80104e51:	83 ec 04             	sub    $0x4,%esp
80104e54:	ff 75 f0             	pushl  -0x10(%ebp)
80104e57:	ff 75 f4             	pushl  -0xc(%ebp)
80104e5a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e5d:	e8 8e c1 ff ff       	call   80100ff0 <filewrite>
80104e62:	83 c4 10             	add    $0x10,%esp
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e75:	c9                   	leave  
80104e76:	c3                   	ret    
80104e77:	89 f6                	mov    %esi,%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <sys_close>:
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	83 ec 18             	sub    $0x18,%esp
80104e86:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e8c:	e8 4f fe ff ff       	call   80104ce0 <argfd.constprop.0>
80104e91:	85 c0                	test   %eax,%eax
80104e93:	78 2b                	js     80104ec0 <sys_close+0x40>
80104e95:	e8 46 e9 ff ff       	call   801037e0 <myproc>
80104e9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e9d:	83 ec 0c             	sub    $0xc,%esp
80104ea0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ea7:	00 
80104ea8:	ff 75 f4             	pushl  -0xc(%ebp)
80104eab:	e8 90 bf ff ff       	call   80100e40 <fileclose>
80104eb0:	83 c4 10             	add    $0x10,%esp
80104eb3:	31 c0                	xor    %eax,%eax
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ec5:	c9                   	leave  
80104ec6:	c3                   	ret    
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ed0 <sys_fstat>:
80104ed0:	55                   	push   %ebp
80104ed1:	31 c0                	xor    %eax,%eax
80104ed3:	89 e5                	mov    %esp,%ebp
80104ed5:	83 ec 18             	sub    $0x18,%esp
80104ed8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104edb:	e8 00 fe ff ff       	call   80104ce0 <argfd.constprop.0>
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	78 2c                	js     80104f10 <sys_fstat+0x40>
80104ee4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ee7:	83 ec 04             	sub    $0x4,%esp
80104eea:	6a 14                	push   $0x14
80104eec:	50                   	push   %eax
80104eed:	6a 01                	push   $0x1
80104eef:	e8 4c fb ff ff       	call   80104a40 <argptr>
80104ef4:	83 c4 10             	add    $0x10,%esp
80104ef7:	85 c0                	test   %eax,%eax
80104ef9:	78 15                	js     80104f10 <sys_fstat+0x40>
80104efb:	83 ec 08             	sub    $0x8,%esp
80104efe:	ff 75 f4             	pushl  -0xc(%ebp)
80104f01:	ff 75 f0             	pushl  -0x10(%ebp)
80104f04:	e8 07 c0 ff ff       	call   80100f10 <filestat>
80104f09:	83 c4 10             	add    $0x10,%esp
80104f0c:	c9                   	leave  
80104f0d:	c3                   	ret    
80104f0e:	66 90                	xchg   %ax,%ax
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f15:	c9                   	leave  
80104f16:	c3                   	ret    
80104f17:	89 f6                	mov    %esi,%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <sys_link>:
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
80104f26:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104f29:	83 ec 34             	sub    $0x34,%esp
80104f2c:	50                   	push   %eax
80104f2d:	6a 00                	push   $0x0
80104f2f:	e8 6c fb ff ff       	call   80104aa0 <argstr>
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	85 c0                	test   %eax,%eax
80104f39:	0f 88 fb 00 00 00    	js     8010503a <sys_link+0x11a>
80104f3f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f42:	83 ec 08             	sub    $0x8,%esp
80104f45:	50                   	push   %eax
80104f46:	6a 01                	push   $0x1
80104f48:	e8 53 fb ff ff       	call   80104aa0 <argstr>
80104f4d:	83 c4 10             	add    $0x10,%esp
80104f50:	85 c0                	test   %eax,%eax
80104f52:	0f 88 e2 00 00 00    	js     8010503a <sys_link+0x11a>
80104f58:	e8 43 dc ff ff       	call   80102ba0 <begin_op>
80104f5d:	83 ec 0c             	sub    $0xc,%esp
80104f60:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f63:	e8 78 cf ff ff       	call   80101ee0 <namei>
80104f68:	83 c4 10             	add    $0x10,%esp
80104f6b:	85 c0                	test   %eax,%eax
80104f6d:	89 c3                	mov    %eax,%ebx
80104f6f:	0f 84 ea 00 00 00    	je     8010505f <sys_link+0x13f>
80104f75:	83 ec 0c             	sub    $0xc,%esp
80104f78:	50                   	push   %eax
80104f79:	e8 02 c7 ff ff       	call   80101680 <ilock>
80104f7e:	83 c4 10             	add    $0x10,%esp
80104f81:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80104f86:	0f 84 bb 00 00 00    	je     80105047 <sys_link+0x127>
80104f8c:	66 83 43 5a 01       	addw   $0x1,0x5a(%ebx)
80104f91:	83 ec 0c             	sub    $0xc,%esp
80104f94:	8d 7d da             	lea    -0x26(%ebp),%edi
80104f97:	53                   	push   %ebx
80104f98:	e8 33 c6 ff ff       	call   801015d0 <iupdate>
80104f9d:	89 1c 24             	mov    %ebx,(%esp)
80104fa0:	e8 bb c7 ff ff       	call   80101760 <iunlock>
80104fa5:	58                   	pop    %eax
80104fa6:	5a                   	pop    %edx
80104fa7:	57                   	push   %edi
80104fa8:	ff 75 d0             	pushl  -0x30(%ebp)
80104fab:	e8 50 cf ff ff       	call   80101f00 <nameiparent>
80104fb0:	83 c4 10             	add    $0x10,%esp
80104fb3:	85 c0                	test   %eax,%eax
80104fb5:	89 c6                	mov    %eax,%esi
80104fb7:	74 5b                	je     80105014 <sys_link+0xf4>
80104fb9:	83 ec 0c             	sub    $0xc,%esp
80104fbc:	50                   	push   %eax
80104fbd:	e8 be c6 ff ff       	call   80101680 <ilock>
80104fc2:	83 c4 10             	add    $0x10,%esp
80104fc5:	8b 03                	mov    (%ebx),%eax
80104fc7:	39 06                	cmp    %eax,(%esi)
80104fc9:	75 3d                	jne    80105008 <sys_link+0xe8>
80104fcb:	83 ec 04             	sub    $0x4,%esp
80104fce:	ff 73 04             	pushl  0x4(%ebx)
80104fd1:	57                   	push   %edi
80104fd2:	56                   	push   %esi
80104fd3:	e8 48 ce ff ff       	call   80101e20 <dirlink>
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	85 c0                	test   %eax,%eax
80104fdd:	78 29                	js     80105008 <sys_link+0xe8>
80104fdf:	83 ec 0c             	sub    $0xc,%esp
80104fe2:	56                   	push   %esi
80104fe3:	e8 28 c9 ff ff       	call   80101910 <iunlockput>
80104fe8:	89 1c 24             	mov    %ebx,(%esp)
80104feb:	e8 c0 c7 ff ff       	call   801017b0 <iput>
80104ff0:	e8 1b dc ff ff       	call   80102c10 <end_op>
80104ff5:	83 c4 10             	add    $0x10,%esp
80104ff8:	31 c0                	xor    %eax,%eax
80104ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ffd:	5b                   	pop    %ebx
80104ffe:	5e                   	pop    %esi
80104fff:	5f                   	pop    %edi
80105000:	5d                   	pop    %ebp
80105001:	c3                   	ret    
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105008:	83 ec 0c             	sub    $0xc,%esp
8010500b:	56                   	push   %esi
8010500c:	e8 ff c8 ff ff       	call   80101910 <iunlockput>
80105011:	83 c4 10             	add    $0x10,%esp
80105014:	83 ec 0c             	sub    $0xc,%esp
80105017:	53                   	push   %ebx
80105018:	e8 63 c6 ff ff       	call   80101680 <ilock>
8010501d:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
80105022:	89 1c 24             	mov    %ebx,(%esp)
80105025:	e8 a6 c5 ff ff       	call   801015d0 <iupdate>
8010502a:	89 1c 24             	mov    %ebx,(%esp)
8010502d:	e8 de c8 ff ff       	call   80101910 <iunlockput>
80105032:	e8 d9 db ff ff       	call   80102c10 <end_op>
80105037:	83 c4 10             	add    $0x10,%esp
8010503a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010503d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105042:	5b                   	pop    %ebx
80105043:	5e                   	pop    %esi
80105044:	5f                   	pop    %edi
80105045:	5d                   	pop    %ebp
80105046:	c3                   	ret    
80105047:	83 ec 0c             	sub    $0xc,%esp
8010504a:	53                   	push   %ebx
8010504b:	e8 c0 c8 ff ff       	call   80101910 <iunlockput>
80105050:	e8 bb db ff ff       	call   80102c10 <end_op>
80105055:	83 c4 10             	add    $0x10,%esp
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505d:	eb 9b                	jmp    80104ffa <sys_link+0xda>
8010505f:	e8 ac db ff ff       	call   80102c10 <end_op>
80105064:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105069:	eb 8f                	jmp    80104ffa <sys_link+0xda>
8010506b:	90                   	nop
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105070 <sys_unlink>:
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	53                   	push   %ebx
80105076:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105079:	83 ec 44             	sub    $0x44,%esp
8010507c:	50                   	push   %eax
8010507d:	6a 00                	push   $0x0
8010507f:	e8 1c fa ff ff       	call   80104aa0 <argstr>
80105084:	83 c4 10             	add    $0x10,%esp
80105087:	85 c0                	test   %eax,%eax
80105089:	0f 88 77 01 00 00    	js     80105206 <sys_unlink+0x196>
8010508f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105092:	e8 09 db ff ff       	call   80102ba0 <begin_op>
80105097:	83 ec 08             	sub    $0x8,%esp
8010509a:	53                   	push   %ebx
8010509b:	ff 75 c0             	pushl  -0x40(%ebp)
8010509e:	e8 5d ce ff ff       	call   80101f00 <nameiparent>
801050a3:	83 c4 10             	add    $0x10,%esp
801050a6:	85 c0                	test   %eax,%eax
801050a8:	89 c6                	mov    %eax,%esi
801050aa:	0f 84 60 01 00 00    	je     80105210 <sys_unlink+0x1a0>
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	50                   	push   %eax
801050b4:	e8 c7 c5 ff ff       	call   80101680 <ilock>
801050b9:	58                   	pop    %eax
801050ba:	5a                   	pop    %edx
801050bb:	68 60 7a 10 80       	push   $0x80107a60
801050c0:	53                   	push   %ebx
801050c1:	e8 ca ca ff ff       	call   80101b90 <namecmp>
801050c6:	83 c4 10             	add    $0x10,%esp
801050c9:	85 c0                	test   %eax,%eax
801050cb:	0f 84 03 01 00 00    	je     801051d4 <sys_unlink+0x164>
801050d1:	83 ec 08             	sub    $0x8,%esp
801050d4:	68 5f 7a 10 80       	push   $0x80107a5f
801050d9:	53                   	push   %ebx
801050da:	e8 b1 ca ff ff       	call   80101b90 <namecmp>
801050df:	83 c4 10             	add    $0x10,%esp
801050e2:	85 c0                	test   %eax,%eax
801050e4:	0f 84 ea 00 00 00    	je     801051d4 <sys_unlink+0x164>
801050ea:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050ed:	83 ec 04             	sub    $0x4,%esp
801050f0:	50                   	push   %eax
801050f1:	53                   	push   %ebx
801050f2:	56                   	push   %esi
801050f3:	e8 b8 ca ff ff       	call   80101bb0 <dirlookup>
801050f8:	83 c4 10             	add    $0x10,%esp
801050fb:	85 c0                	test   %eax,%eax
801050fd:	89 c3                	mov    %eax,%ebx
801050ff:	0f 84 cf 00 00 00    	je     801051d4 <sys_unlink+0x164>
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	50                   	push   %eax
80105109:	e8 72 c5 ff ff       	call   80101680 <ilock>
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	66 83 7b 5a 00       	cmpw   $0x0,0x5a(%ebx)
80105116:	0f 8e 10 01 00 00    	jle    8010522c <sys_unlink+0x1bc>
8010511c:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105121:	74 6d                	je     80105190 <sys_unlink+0x120>
80105123:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105126:	83 ec 04             	sub    $0x4,%esp
80105129:	6a 10                	push   $0x10
8010512b:	6a 00                	push   $0x0
8010512d:	50                   	push   %eax
8010512e:	e8 bd f5 ff ff       	call   801046f0 <memset>
80105133:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105136:	6a 10                	push   $0x10
80105138:	ff 75 c4             	pushl  -0x3c(%ebp)
8010513b:	50                   	push   %eax
8010513c:	56                   	push   %esi
8010513d:	e8 1e c9 ff ff       	call   80101a60 <writei>
80105142:	83 c4 20             	add    $0x20,%esp
80105145:	83 f8 10             	cmp    $0x10,%eax
80105148:	0f 85 eb 00 00 00    	jne    80105239 <sys_unlink+0x1c9>
8010514e:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
80105153:	0f 84 97 00 00 00    	je     801051f0 <sys_unlink+0x180>
80105159:	83 ec 0c             	sub    $0xc,%esp
8010515c:	56                   	push   %esi
8010515d:	e8 ae c7 ff ff       	call   80101910 <iunlockput>
80105162:	66 83 6b 5a 01       	subw   $0x1,0x5a(%ebx)
80105167:	89 1c 24             	mov    %ebx,(%esp)
8010516a:	e8 61 c4 ff ff       	call   801015d0 <iupdate>
8010516f:	89 1c 24             	mov    %ebx,(%esp)
80105172:	e8 99 c7 ff ff       	call   80101910 <iunlockput>
80105177:	e8 94 da ff ff       	call   80102c10 <end_op>
8010517c:	83 c4 10             	add    $0x10,%esp
8010517f:	31 c0                	xor    %eax,%eax
80105181:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105184:	5b                   	pop    %ebx
80105185:	5e                   	pop    %esi
80105186:	5f                   	pop    %edi
80105187:	5d                   	pop    %ebp
80105188:	c3                   	ret    
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105190:	83 7b 5c 20          	cmpl   $0x20,0x5c(%ebx)
80105194:	76 8d                	jbe    80105123 <sys_unlink+0xb3>
80105196:	bf 20 00 00 00       	mov    $0x20,%edi
8010519b:	eb 0f                	jmp    801051ac <sys_unlink+0x13c>
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
801051a0:	83 c7 10             	add    $0x10,%edi
801051a3:	3b 7b 5c             	cmp    0x5c(%ebx),%edi
801051a6:	0f 83 77 ff ff ff    	jae    80105123 <sys_unlink+0xb3>
801051ac:	8d 45 d8             	lea    -0x28(%ebp),%eax
801051af:	6a 10                	push   $0x10
801051b1:	57                   	push   %edi
801051b2:	50                   	push   %eax
801051b3:	53                   	push   %ebx
801051b4:	e8 a7 c7 ff ff       	call   80101960 <readi>
801051b9:	83 c4 10             	add    $0x10,%esp
801051bc:	83 f8 10             	cmp    $0x10,%eax
801051bf:	75 5e                	jne    8010521f <sys_unlink+0x1af>
801051c1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051c6:	74 d8                	je     801051a0 <sys_unlink+0x130>
801051c8:	83 ec 0c             	sub    $0xc,%esp
801051cb:	53                   	push   %ebx
801051cc:	e8 3f c7 ff ff       	call   80101910 <iunlockput>
801051d1:	83 c4 10             	add    $0x10,%esp
801051d4:	83 ec 0c             	sub    $0xc,%esp
801051d7:	56                   	push   %esi
801051d8:	e8 33 c7 ff ff       	call   80101910 <iunlockput>
801051dd:	e8 2e da ff ff       	call   80102c10 <end_op>
801051e2:	83 c4 10             	add    $0x10,%esp
801051e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ea:	eb 95                	jmp    80105181 <sys_unlink+0x111>
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051f0:	66 83 6e 5a 01       	subw   $0x1,0x5a(%esi)
801051f5:	83 ec 0c             	sub    $0xc,%esp
801051f8:	56                   	push   %esi
801051f9:	e8 d2 c3 ff ff       	call   801015d0 <iupdate>
801051fe:	83 c4 10             	add    $0x10,%esp
80105201:	e9 53 ff ff ff       	jmp    80105159 <sys_unlink+0xe9>
80105206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520b:	e9 71 ff ff ff       	jmp    80105181 <sys_unlink+0x111>
80105210:	e8 fb d9 ff ff       	call   80102c10 <end_op>
80105215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521a:	e9 62 ff ff ff       	jmp    80105181 <sys_unlink+0x111>
8010521f:	83 ec 0c             	sub    $0xc,%esp
80105222:	68 84 7a 10 80       	push   $0x80107a84
80105227:	e8 64 b1 ff ff       	call   80100390 <panic>
8010522c:	83 ec 0c             	sub    $0xc,%esp
8010522f:	68 72 7a 10 80       	push   $0x80107a72
80105234:	e8 57 b1 ff ff       	call   80100390 <panic>
80105239:	83 ec 0c             	sub    $0xc,%esp
8010523c:	68 96 7a 10 80       	push   $0x80107a96
80105241:	e8 4a b1 ff ff       	call   80100390 <panic>
80105246:	8d 76 00             	lea    0x0(%esi),%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sys_open>:
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
80105255:	53                   	push   %ebx
80105256:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105259:	83 ec 24             	sub    $0x24,%esp
8010525c:	50                   	push   %eax
8010525d:	6a 00                	push   $0x0
8010525f:	e8 3c f8 ff ff       	call   80104aa0 <argstr>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	0f 88 1d 01 00 00    	js     8010538c <sys_open+0x13c>
8010526f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105272:	83 ec 08             	sub    $0x8,%esp
80105275:	50                   	push   %eax
80105276:	6a 01                	push   $0x1
80105278:	e8 73 f7 ff ff       	call   801049f0 <argint>
8010527d:	83 c4 10             	add    $0x10,%esp
80105280:	85 c0                	test   %eax,%eax
80105282:	0f 88 04 01 00 00    	js     8010538c <sys_open+0x13c>
80105288:	e8 13 d9 ff ff       	call   80102ba0 <begin_op>
8010528d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105291:	0f 85 a9 00 00 00    	jne    80105340 <sys_open+0xf0>
80105297:	83 ec 0c             	sub    $0xc,%esp
8010529a:	ff 75 e0             	pushl  -0x20(%ebp)
8010529d:	e8 3e cc ff ff       	call   80101ee0 <namei>
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	85 c0                	test   %eax,%eax
801052a7:	89 c6                	mov    %eax,%esi
801052a9:	0f 84 b2 00 00 00    	je     80105361 <sys_open+0x111>
801052af:	83 ec 0c             	sub    $0xc,%esp
801052b2:	50                   	push   %eax
801052b3:	e8 c8 c3 ff ff       	call   80101680 <ilock>
801052b8:	83 c4 10             	add    $0x10,%esp
801052bb:	66 83 7e 54 01       	cmpw   $0x1,0x54(%esi)
801052c0:	0f 84 aa 00 00 00    	je     80105370 <sys_open+0x120>
801052c6:	e8 b5 ba ff ff       	call   80100d80 <filealloc>
801052cb:	85 c0                	test   %eax,%eax
801052cd:	89 c7                	mov    %eax,%edi
801052cf:	0f 84 a6 00 00 00    	je     8010537b <sys_open+0x12b>
801052d5:	e8 06 e5 ff ff       	call   801037e0 <myproc>
801052da:	31 db                	xor    %ebx,%ebx
801052dc:	eb 0e                	jmp    801052ec <sys_open+0x9c>
801052de:	66 90                	xchg   %ax,%ax
801052e0:	83 c3 01             	add    $0x1,%ebx
801052e3:	83 fb 10             	cmp    $0x10,%ebx
801052e6:	0f 84 ac 00 00 00    	je     80105398 <sys_open+0x148>
801052ec:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052f0:	85 d2                	test   %edx,%edx
801052f2:	75 ec                	jne    801052e0 <sys_open+0x90>
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
801052fb:	56                   	push   %esi
801052fc:	e8 5f c4 ff ff       	call   80101760 <iunlock>
80105301:	e8 0a d9 ff ff       	call   80102c10 <end_op>
80105306:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
8010530c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	89 77 10             	mov    %esi,0x10(%edi)
80105315:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
8010531c:	89 d0                	mov    %edx,%eax
8010531e:	f7 d0                	not    %eax
80105320:	83 e0 01             	and    $0x1,%eax
80105323:	83 e2 03             	and    $0x3,%edx
80105326:	88 47 08             	mov    %al,0x8(%edi)
80105329:	0f 95 47 09          	setne  0x9(%edi)
8010532d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105330:	89 d8                	mov    %ebx,%eax
80105332:	5b                   	pop    %ebx
80105333:	5e                   	pop    %esi
80105334:	5f                   	pop    %edi
80105335:	5d                   	pop    %ebp
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105346:	31 c9                	xor    %ecx,%ecx
80105348:	6a 00                	push   $0x0
8010534a:	ba 02 00 00 00       	mov    $0x2,%edx
8010534f:	e8 ec f7 ff ff       	call   80104b40 <create>
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	85 c0                	test   %eax,%eax
80105359:	89 c6                	mov    %eax,%esi
8010535b:	0f 85 65 ff ff ff    	jne    801052c6 <sys_open+0x76>
80105361:	e8 aa d8 ff ff       	call   80102c10 <end_op>
80105366:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010536b:	eb c0                	jmp    8010532d <sys_open+0xdd>
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
80105370:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105373:	85 c9                	test   %ecx,%ecx
80105375:	0f 84 4b ff ff ff    	je     801052c6 <sys_open+0x76>
8010537b:	83 ec 0c             	sub    $0xc,%esp
8010537e:	56                   	push   %esi
8010537f:	e8 8c c5 ff ff       	call   80101910 <iunlockput>
80105384:	e8 87 d8 ff ff       	call   80102c10 <end_op>
80105389:	83 c4 10             	add    $0x10,%esp
8010538c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105391:	eb 9a                	jmp    8010532d <sys_open+0xdd>
80105393:	90                   	nop
80105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105398:	83 ec 0c             	sub    $0xc,%esp
8010539b:	57                   	push   %edi
8010539c:	e8 9f ba ff ff       	call   80100e40 <fileclose>
801053a1:	83 c4 10             	add    $0x10,%esp
801053a4:	eb d5                	jmp    8010537b <sys_open+0x12b>
801053a6:	8d 76 00             	lea    0x0(%esi),%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <sys_mkdir>:
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 18             	sub    $0x18,%esp
801053b6:	e8 e5 d7 ff ff       	call   80102ba0 <begin_op>
801053bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053be:	83 ec 08             	sub    $0x8,%esp
801053c1:	50                   	push   %eax
801053c2:	6a 00                	push   $0x0
801053c4:	e8 d7 f6 ff ff       	call   80104aa0 <argstr>
801053c9:	83 c4 10             	add    $0x10,%esp
801053cc:	85 c0                	test   %eax,%eax
801053ce:	78 30                	js     80105400 <sys_mkdir+0x50>
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d6:	31 c9                	xor    %ecx,%ecx
801053d8:	6a 00                	push   $0x0
801053da:	ba 01 00 00 00       	mov    $0x1,%edx
801053df:	e8 5c f7 ff ff       	call   80104b40 <create>
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	85 c0                	test   %eax,%eax
801053e9:	74 15                	je     80105400 <sys_mkdir+0x50>
801053eb:	83 ec 0c             	sub    $0xc,%esp
801053ee:	50                   	push   %eax
801053ef:	e8 1c c5 ff ff       	call   80101910 <iunlockput>
801053f4:	e8 17 d8 ff ff       	call   80102c10 <end_op>
801053f9:	83 c4 10             	add    $0x10,%esp
801053fc:	31 c0                	xor    %eax,%eax
801053fe:	c9                   	leave  
801053ff:	c3                   	ret    
80105400:	e8 0b d8 ff ff       	call   80102c10 <end_op>
80105405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010540a:	c9                   	leave  
8010540b:	c3                   	ret    
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_mknod>:
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 18             	sub    $0x18,%esp
80105416:	e8 85 d7 ff ff       	call   80102ba0 <begin_op>
8010541b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010541e:	83 ec 08             	sub    $0x8,%esp
80105421:	50                   	push   %eax
80105422:	6a 00                	push   $0x0
80105424:	e8 77 f6 ff ff       	call   80104aa0 <argstr>
80105429:	83 c4 10             	add    $0x10,%esp
8010542c:	85 c0                	test   %eax,%eax
8010542e:	78 60                	js     80105490 <sys_mknod+0x80>
80105430:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105433:	83 ec 08             	sub    $0x8,%esp
80105436:	50                   	push   %eax
80105437:	6a 01                	push   $0x1
80105439:	e8 b2 f5 ff ff       	call   801049f0 <argint>
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	85 c0                	test   %eax,%eax
80105443:	78 4b                	js     80105490 <sys_mknod+0x80>
80105445:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105448:	83 ec 08             	sub    $0x8,%esp
8010544b:	50                   	push   %eax
8010544c:	6a 02                	push   $0x2
8010544e:	e8 9d f5 ff ff       	call   801049f0 <argint>
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	85 c0                	test   %eax,%eax
80105458:	78 36                	js     80105490 <sys_mknod+0x80>
8010545a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010545e:	83 ec 0c             	sub    $0xc,%esp
80105461:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105465:	ba 03 00 00 00       	mov    $0x3,%edx
8010546a:	50                   	push   %eax
8010546b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010546e:	e8 cd f6 ff ff       	call   80104b40 <create>
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	74 16                	je     80105490 <sys_mknod+0x80>
8010547a:	83 ec 0c             	sub    $0xc,%esp
8010547d:	50                   	push   %eax
8010547e:	e8 8d c4 ff ff       	call   80101910 <iunlockput>
80105483:	e8 88 d7 ff ff       	call   80102c10 <end_op>
80105488:	83 c4 10             	add    $0x10,%esp
8010548b:	31 c0                	xor    %eax,%eax
8010548d:	c9                   	leave  
8010548e:	c3                   	ret    
8010548f:	90                   	nop
80105490:	e8 7b d7 ff ff       	call   80102c10 <end_op>
80105495:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549a:	c9                   	leave  
8010549b:	c3                   	ret    
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054a0 <sys_chdir>:
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	56                   	push   %esi
801054a4:	53                   	push   %ebx
801054a5:	83 ec 10             	sub    $0x10,%esp
801054a8:	e8 33 e3 ff ff       	call   801037e0 <myproc>
801054ad:	89 c6                	mov    %eax,%esi
801054af:	e8 ec d6 ff ff       	call   80102ba0 <begin_op>
801054b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054b7:	83 ec 08             	sub    $0x8,%esp
801054ba:	50                   	push   %eax
801054bb:	6a 00                	push   $0x0
801054bd:	e8 de f5 ff ff       	call   80104aa0 <argstr>
801054c2:	83 c4 10             	add    $0x10,%esp
801054c5:	85 c0                	test   %eax,%eax
801054c7:	78 77                	js     80105540 <sys_chdir+0xa0>
801054c9:	83 ec 0c             	sub    $0xc,%esp
801054cc:	ff 75 f4             	pushl  -0xc(%ebp)
801054cf:	e8 0c ca ff ff       	call   80101ee0 <namei>
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	85 c0                	test   %eax,%eax
801054d9:	89 c3                	mov    %eax,%ebx
801054db:	74 63                	je     80105540 <sys_chdir+0xa0>
801054dd:	83 ec 0c             	sub    $0xc,%esp
801054e0:	50                   	push   %eax
801054e1:	e8 9a c1 ff ff       	call   80101680 <ilock>
801054e6:	83 c4 10             	add    $0x10,%esp
801054e9:	66 83 7b 54 01       	cmpw   $0x1,0x54(%ebx)
801054ee:	75 30                	jne    80105520 <sys_chdir+0x80>
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	53                   	push   %ebx
801054f4:	e8 67 c2 ff ff       	call   80101760 <iunlock>
801054f9:	58                   	pop    %eax
801054fa:	ff 76 68             	pushl  0x68(%esi)
801054fd:	e8 ae c2 ff ff       	call   801017b0 <iput>
80105502:	e8 09 d7 ff ff       	call   80102c10 <end_op>
80105507:	89 5e 68             	mov    %ebx,0x68(%esi)
8010550a:	83 c4 10             	add    $0x10,%esp
8010550d:	31 c0                	xor    %eax,%eax
8010550f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105512:	5b                   	pop    %ebx
80105513:	5e                   	pop    %esi
80105514:	5d                   	pop    %ebp
80105515:	c3                   	ret    
80105516:	8d 76 00             	lea    0x0(%esi),%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	53                   	push   %ebx
80105524:	e8 e7 c3 ff ff       	call   80101910 <iunlockput>
80105529:	e8 e2 d6 ff ff       	call   80102c10 <end_op>
8010552e:	83 c4 10             	add    $0x10,%esp
80105531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105536:	eb d7                	jmp    8010550f <sys_chdir+0x6f>
80105538:	90                   	nop
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105540:	e8 cb d6 ff ff       	call   80102c10 <end_op>
80105545:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554a:	eb c3                	jmp    8010550f <sys_chdir+0x6f>
8010554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105550 <sys_exec>:
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
80105555:	53                   	push   %ebx
80105556:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
8010555c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
80105562:	50                   	push   %eax
80105563:	6a 00                	push   $0x0
80105565:	e8 36 f5 ff ff       	call   80104aa0 <argstr>
8010556a:	83 c4 10             	add    $0x10,%esp
8010556d:	85 c0                	test   %eax,%eax
8010556f:	0f 88 87 00 00 00    	js     801055fc <sys_exec+0xac>
80105575:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010557b:	83 ec 08             	sub    $0x8,%esp
8010557e:	50                   	push   %eax
8010557f:	6a 01                	push   $0x1
80105581:	e8 6a f4 ff ff       	call   801049f0 <argint>
80105586:	83 c4 10             	add    $0x10,%esp
80105589:	85 c0                	test   %eax,%eax
8010558b:	78 6f                	js     801055fc <sys_exec+0xac>
8010558d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105593:	83 ec 04             	sub    $0x4,%esp
80105596:	31 db                	xor    %ebx,%ebx
80105598:	68 80 00 00 00       	push   $0x80
8010559d:	6a 00                	push   $0x0
8010559f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801055a5:	50                   	push   %eax
801055a6:	e8 45 f1 ff ff       	call   801046f0 <memset>
801055ab:	83 c4 10             	add    $0x10,%esp
801055ae:	eb 2c                	jmp    801055dc <sys_exec+0x8c>
801055b0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055b6:	85 c0                	test   %eax,%eax
801055b8:	74 56                	je     80105610 <sys_exec+0xc0>
801055ba:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801055c0:	83 ec 08             	sub    $0x8,%esp
801055c3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801055c6:	52                   	push   %edx
801055c7:	50                   	push   %eax
801055c8:	e8 b3 f3 ff ff       	call   80104980 <fetchstr>
801055cd:	83 c4 10             	add    $0x10,%esp
801055d0:	85 c0                	test   %eax,%eax
801055d2:	78 28                	js     801055fc <sys_exec+0xac>
801055d4:	83 c3 01             	add    $0x1,%ebx
801055d7:	83 fb 20             	cmp    $0x20,%ebx
801055da:	74 20                	je     801055fc <sys_exec+0xac>
801055dc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055e2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801055e9:	83 ec 08             	sub    $0x8,%esp
801055ec:	57                   	push   %edi
801055ed:	01 f0                	add    %esi,%eax
801055ef:	50                   	push   %eax
801055f0:	e8 4b f3 ff ff       	call   80104940 <fetchint>
801055f5:	83 c4 10             	add    $0x10,%esp
801055f8:	85 c0                	test   %eax,%eax
801055fa:	79 b4                	jns    801055b0 <sys_exec+0x60>
801055fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105604:	5b                   	pop    %ebx
80105605:	5e                   	pop    %esi
80105606:	5f                   	pop    %edi
80105607:	5d                   	pop    %ebp
80105608:	c3                   	ret    
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105610:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105616:	83 ec 08             	sub    $0x8,%esp
80105619:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105620:	00 00 00 00 
80105624:	50                   	push   %eax
80105625:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010562b:	e8 e0 b3 ff ff       	call   80100a10 <exec>
80105630:	83 c4 10             	add    $0x10,%esp
80105633:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105636:	5b                   	pop    %ebx
80105637:	5e                   	pop    %esi
80105638:	5f                   	pop    %edi
80105639:	5d                   	pop    %ebp
8010563a:	c3                   	ret    
8010563b:	90                   	nop
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105640 <sys_pipe>:
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
80105645:	53                   	push   %ebx
80105646:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105649:	83 ec 20             	sub    $0x20,%esp
8010564c:	6a 08                	push   $0x8
8010564e:	50                   	push   %eax
8010564f:	6a 00                	push   $0x0
80105651:	e8 ea f3 ff ff       	call   80104a40 <argptr>
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	85 c0                	test   %eax,%eax
8010565b:	0f 88 ae 00 00 00    	js     8010570f <sys_pipe+0xcf>
80105661:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105664:	83 ec 08             	sub    $0x8,%esp
80105667:	50                   	push   %eax
80105668:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010566b:	50                   	push   %eax
8010566c:	e8 cf db ff ff       	call   80103240 <pipealloc>
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	85 c0                	test   %eax,%eax
80105676:	0f 88 93 00 00 00    	js     8010570f <sys_pipe+0xcf>
8010567c:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010567f:	31 db                	xor    %ebx,%ebx
80105681:	e8 5a e1 ff ff       	call   801037e0 <myproc>
80105686:	eb 10                	jmp    80105698 <sys_pipe+0x58>
80105688:	90                   	nop
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105690:	83 c3 01             	add    $0x1,%ebx
80105693:	83 fb 10             	cmp    $0x10,%ebx
80105696:	74 60                	je     801056f8 <sys_pipe+0xb8>
80105698:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010569c:	85 f6                	test   %esi,%esi
8010569e:	75 f0                	jne    80105690 <sys_pipe+0x50>
801056a0:	8d 73 08             	lea    0x8(%ebx),%esi
801056a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
801056a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801056aa:	e8 31 e1 ff ff       	call   801037e0 <myproc>
801056af:	31 d2                	xor    %edx,%edx
801056b1:	eb 0d                	jmp    801056c0 <sys_pipe+0x80>
801056b3:	90                   	nop
801056b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056b8:	83 c2 01             	add    $0x1,%edx
801056bb:	83 fa 10             	cmp    $0x10,%edx
801056be:	74 28                	je     801056e8 <sys_pipe+0xa8>
801056c0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056c4:	85 c9                	test   %ecx,%ecx
801056c6:	75 f0                	jne    801056b8 <sys_pipe+0x78>
801056c8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
801056cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056cf:	89 18                	mov    %ebx,(%eax)
801056d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056d4:	89 50 04             	mov    %edx,0x4(%eax)
801056d7:	31 c0                	xor    %eax,%eax
801056d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056dc:	5b                   	pop    %ebx
801056dd:	5e                   	pop    %esi
801056de:	5f                   	pop    %edi
801056df:	5d                   	pop    %ebp
801056e0:	c3                   	ret    
801056e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056e8:	e8 f3 e0 ff ff       	call   801037e0 <myproc>
801056ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056f4:	00 
801056f5:	8d 76 00             	lea    0x0(%esi),%esi
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	ff 75 e0             	pushl  -0x20(%ebp)
801056fe:	e8 3d b7 ff ff       	call   80100e40 <fileclose>
80105703:	58                   	pop    %eax
80105704:	ff 75 e4             	pushl  -0x1c(%ebp)
80105707:	e8 34 b7 ff ff       	call   80100e40 <fileclose>
8010570c:	83 c4 10             	add    $0x10,%esp
8010570f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105714:	eb c3                	jmp    801056d9 <sys_pipe+0x99>
80105716:	66 90                	xchg   %ax,%ax
80105718:	66 90                	xchg   %ax,%ax
8010571a:	66 90                	xchg   %ax,%ax
8010571c:	66 90                	xchg   %ax,%ax
8010571e:	66 90                	xchg   %ax,%ax

80105720 <sys_fork>:
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	5d                   	pop    %ebp
80105724:	e9 57 e2 ff ff       	jmp    80103980 <fork>
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_exit>:
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 08             	sub    $0x8,%esp
80105736:	e8 c5 e4 ff ff       	call   80103c00 <exit>
8010573b:	31 c0                	xor    %eax,%eax
8010573d:	c9                   	leave  
8010573e:	c3                   	ret    
8010573f:	90                   	nop

80105740 <sys_wait>:
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	5d                   	pop    %ebp
80105744:	e9 f7 e6 ff ff       	jmp    80103e40 <wait>
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_kill>:
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 20             	sub    $0x20,%esp
80105756:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105759:	50                   	push   %eax
8010575a:	6a 00                	push   $0x0
8010575c:	e8 8f f2 ff ff       	call   801049f0 <argint>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	85 c0                	test   %eax,%eax
80105766:	78 18                	js     80105780 <sys_kill+0x30>
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	ff 75 f4             	pushl  -0xc(%ebp)
8010576e:	e8 1d e8 ff ff       	call   80103f90 <kill>
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	c9                   	leave  
80105777:	c3                   	ret    
80105778:	90                   	nop
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105785:	c9                   	leave  
80105786:	c3                   	ret    
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <sys_getpid>:
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 08             	sub    $0x8,%esp
80105796:	e8 45 e0 ff ff       	call   801037e0 <myproc>
8010579b:	8b 40 10             	mov    0x10(%eax),%eax
8010579e:	c9                   	leave  
8010579f:	c3                   	ret    

801057a0 <sys_sbrk>:
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	53                   	push   %ebx
801057a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057a7:	83 ec 1c             	sub    $0x1c,%esp
801057aa:	50                   	push   %eax
801057ab:	6a 00                	push   $0x0
801057ad:	e8 3e f2 ff ff       	call   801049f0 <argint>
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	85 c0                	test   %eax,%eax
801057b7:	78 27                	js     801057e0 <sys_sbrk+0x40>
801057b9:	e8 22 e0 ff ff       	call   801037e0 <myproc>
801057be:	83 ec 0c             	sub    $0xc,%esp
801057c1:	8b 18                	mov    (%eax),%ebx
801057c3:	ff 75 f4             	pushl  -0xc(%ebp)
801057c6:	e8 35 e1 ff ff       	call   80103900 <growproc>
801057cb:	83 c4 10             	add    $0x10,%esp
801057ce:	85 c0                	test   %eax,%eax
801057d0:	78 0e                	js     801057e0 <sys_sbrk+0x40>
801057d2:	89 d8                	mov    %ebx,%eax
801057d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057d7:	c9                   	leave  
801057d8:	c3                   	ret    
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057e5:	eb eb                	jmp    801057d2 <sys_sbrk+0x32>
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_sleep>:
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	53                   	push   %ebx
801057f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057f7:	83 ec 1c             	sub    $0x1c,%esp
801057fa:	50                   	push   %eax
801057fb:	6a 00                	push   $0x0
801057fd:	e8 ee f1 ff ff       	call   801049f0 <argint>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	85 c0                	test   %eax,%eax
80105807:	0f 88 8a 00 00 00    	js     80105897 <sys_sleep+0xa7>
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	68 80 4e 11 80       	push   $0x80114e80
80105815:	e8 b6 ed ff ff       	call   801045d0 <acquire>
8010581a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	8b 1d c0 56 11 80    	mov    0x801156c0,%ebx
80105826:	85 d2                	test   %edx,%edx
80105828:	75 27                	jne    80105851 <sys_sleep+0x61>
8010582a:	eb 54                	jmp    80105880 <sys_sleep+0x90>
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	68 80 4e 11 80       	push   $0x80114e80
80105838:	68 c0 56 11 80       	push   $0x801156c0
8010583d:	e8 3e e5 ff ff       	call   80103d80 <sleep>
80105842:	a1 c0 56 11 80       	mov    0x801156c0,%eax
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	29 d8                	sub    %ebx,%eax
8010584c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010584f:	73 2f                	jae    80105880 <sys_sleep+0x90>
80105851:	e8 8a df ff ff       	call   801037e0 <myproc>
80105856:	8b 40 24             	mov    0x24(%eax),%eax
80105859:	85 c0                	test   %eax,%eax
8010585b:	74 d3                	je     80105830 <sys_sleep+0x40>
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	68 80 4e 11 80       	push   $0x80114e80
80105865:	e8 36 ee ff ff       	call   801046a0 <release>
8010586a:	83 c4 10             	add    $0x10,%esp
8010586d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105875:	c9                   	leave  
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	68 80 4e 11 80       	push   $0x80114e80
80105888:	e8 13 ee ff ff       	call   801046a0 <release>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	31 c0                	xor    %eax,%eax
80105892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105895:	c9                   	leave  
80105896:	c3                   	ret    
80105897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589c:	eb f4                	jmp    80105892 <sys_sleep+0xa2>
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_uptime>:
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	53                   	push   %ebx
801058a4:	83 ec 10             	sub    $0x10,%esp
801058a7:	68 80 4e 11 80       	push   $0x80114e80
801058ac:	e8 1f ed ff ff       	call   801045d0 <acquire>
801058b1:	8b 1d c0 56 11 80    	mov    0x801156c0,%ebx
801058b7:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
801058be:	e8 dd ed ff ff       	call   801046a0 <release>
801058c3:	89 d8                	mov    %ebx,%eax
801058c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c8:	c9                   	leave  
801058c9:	c3                   	ret    
801058ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058d0 <sys_reentrant>:
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	83 ec 08             	sub    $0x8,%esp
801058d6:	e8 35 e8 ff ff       	call   80104110 <reentrant>
801058db:	31 c0                	xor    %eax,%eax
801058dd:	c9                   	leave  
801058de:	c3                   	ret    
801058df:	90                   	nop

801058e0 <sys_barrier>:
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 20             	sub    $0x20,%esp
801058e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058e9:	50                   	push   %eax
801058ea:	6a 00                	push   $0x0
801058ec:	e8 ff f0 ff ff       	call   801049f0 <argint>
801058f1:	83 c4 10             	add    $0x10,%esp
801058f4:	85 c0                	test   %eax,%eax
801058f6:	78 18                	js     80105910 <sys_barrier+0x30>
801058f8:	83 ec 0c             	sub    $0xc,%esp
801058fb:	ff 75 f4             	pushl  -0xc(%ebp)
801058fe:	e8 6d e8 ff ff       	call   80104170 <barrier>
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	31 c0                	xor    %eax,%eax
80105908:	c9                   	leave  
80105909:	c3                   	ret    
8010590a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105915:	c9                   	leave  
80105916:	c3                   	ret    
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <sys_init_barrier>:
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	83 ec 08             	sub    $0x8,%esp
80105926:	e8 d5 e9 ff ff       	call   80104300 <init_barrier>
8010592b:	31 c0                	xor    %eax,%eax
8010592d:	c9                   	leave  
8010592e:	c3                   	ret    

8010592f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010592f:	1e                   	push   %ds
  pushl %es
80105930:	06                   	push   %es
  pushl %fs
80105931:	0f a0                	push   %fs
  pushl %gs
80105933:	0f a8                	push   %gs
  pushal
80105935:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105936:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010593a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010593c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010593e:	54                   	push   %esp
  call trap
8010593f:	e8 cc 00 00 00       	call   80105a10 <trap>
  addl $4, %esp
80105944:	83 c4 04             	add    $0x4,%esp

80105947 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105947:	61                   	popa   
  popl %gs
80105948:	0f a9                	pop    %gs
  popl %fs
8010594a:	0f a1                	pop    %fs
  popl %es
8010594c:	07                   	pop    %es
  popl %ds
8010594d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010594e:	83 c4 08             	add    $0x8,%esp
  iret
80105951:	cf                   	iret   
80105952:	66 90                	xchg   %ax,%ax
80105954:	66 90                	xchg   %ax,%ax
80105956:	66 90                	xchg   %ax,%ax
80105958:	66 90                	xchg   %ax,%ax
8010595a:	66 90                	xchg   %ax,%ax
8010595c:	66 90                	xchg   %ax,%ax
8010595e:	66 90                	xchg   %ax,%ax

80105960 <tvinit>:
80105960:	55                   	push   %ebp
80105961:	31 c0                	xor    %eax,%eax
80105963:	89 e5                	mov    %esp,%ebp
80105965:	83 ec 08             	sub    $0x8,%esp
80105968:	90                   	nop
80105969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105970:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105977:	c7 04 c5 c2 4e 11 80 	movl   $0x8e000008,-0x7feeb13e(,%eax,8)
8010597e:	08 00 00 8e 
80105982:	66 89 14 c5 c0 4e 11 	mov    %dx,-0x7feeb140(,%eax,8)
80105989:	80 
8010598a:	c1 ea 10             	shr    $0x10,%edx
8010598d:	66 89 14 c5 c6 4e 11 	mov    %dx,-0x7feeb13a(,%eax,8)
80105994:	80 
80105995:	83 c0 01             	add    $0x1,%eax
80105998:	3d 00 01 00 00       	cmp    $0x100,%eax
8010599d:	75 d1                	jne    80105970 <tvinit+0x10>
8010599f:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801059a4:	83 ec 08             	sub    $0x8,%esp
801059a7:	c7 05 c2 50 11 80 08 	movl   $0xef000008,0x801150c2
801059ae:	00 00 ef 
801059b1:	68 a5 7a 10 80       	push   $0x80107aa5
801059b6:	68 80 4e 11 80       	push   $0x80114e80
801059bb:	66 a3 c0 50 11 80    	mov    %ax,0x801150c0
801059c1:	c1 e8 10             	shr    $0x10,%eax
801059c4:	66 a3 c6 50 11 80    	mov    %ax,0x801150c6
801059ca:	e8 a1 ea ff ff       	call   80104470 <initlock>
801059cf:	83 c4 10             	add    $0x10,%esp
801059d2:	c9                   	leave  
801059d3:	c3                   	ret    
801059d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801059e0 <idtinit>:
801059e0:	55                   	push   %ebp
801059e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059e6:	89 e5                	mov    %esp,%ebp
801059e8:	83 ec 10             	sub    $0x10,%esp
801059eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
801059ef:	b8 c0 4e 11 80       	mov    $0x80114ec0,%eax
801059f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801059f8:	c1 e8 10             	shr    $0x10,%eax
801059fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
801059ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a02:	0f 01 18             	lidtl  (%eax)
80105a05:	c9                   	leave  
80105a06:	c3                   	ret    
80105a07:	89 f6                	mov    %esi,%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a10 <trap>:
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	57                   	push   %edi
80105a14:	56                   	push   %esi
80105a15:	53                   	push   %ebx
80105a16:	83 ec 1c             	sub    $0x1c,%esp
80105a19:	8b 7d 08             	mov    0x8(%ebp),%edi
80105a1c:	8b 47 30             	mov    0x30(%edi),%eax
80105a1f:	83 f8 40             	cmp    $0x40,%eax
80105a22:	0f 84 f0 00 00 00    	je     80105b18 <trap+0x108>
80105a28:	83 e8 20             	sub    $0x20,%eax
80105a2b:	83 f8 1f             	cmp    $0x1f,%eax
80105a2e:	77 10                	ja     80105a40 <trap+0x30>
80105a30:	ff 24 85 4c 7b 10 80 	jmp    *-0x7fef84b4(,%eax,4)
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105a40:	e8 9b dd ff ff       	call   801037e0 <myproc>
80105a45:	85 c0                	test   %eax,%eax
80105a47:	8b 5f 38             	mov    0x38(%edi),%ebx
80105a4a:	0f 84 14 02 00 00    	je     80105c64 <trap+0x254>
80105a50:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105a54:	0f 84 0a 02 00 00    	je     80105c64 <trap+0x254>
80105a5a:	0f 20 d1             	mov    %cr2,%ecx
80105a5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105a60:	e8 5b dd ff ff       	call   801037c0 <cpuid>
80105a65:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a68:	8b 47 34             	mov    0x34(%edi),%eax
80105a6b:	8b 77 30             	mov    0x30(%edi),%esi
80105a6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105a71:	e8 6a dd ff ff       	call   801037e0 <myproc>
80105a76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a79:	e8 62 dd ff ff       	call   801037e0 <myproc>
80105a7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a84:	51                   	push   %ecx
80105a85:	53                   	push   %ebx
80105a86:	52                   	push   %edx
80105a87:	8b 55 e0             	mov    -0x20(%ebp),%edx
80105a8a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a8d:	56                   	push   %esi
80105a8e:	83 c2 6c             	add    $0x6c,%edx
80105a91:	52                   	push   %edx
80105a92:	ff 70 10             	pushl  0x10(%eax)
80105a95:	68 08 7b 10 80       	push   $0x80107b08
80105a9a:	e8 c1 ab ff ff       	call   80100660 <cprintf>
80105a9f:	83 c4 20             	add    $0x20,%esp
80105aa2:	e8 39 dd ff ff       	call   801037e0 <myproc>
80105aa7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105aae:	e8 2d dd ff ff       	call   801037e0 <myproc>
80105ab3:	85 c0                	test   %eax,%eax
80105ab5:	74 1d                	je     80105ad4 <trap+0xc4>
80105ab7:	e8 24 dd ff ff       	call   801037e0 <myproc>
80105abc:	8b 50 24             	mov    0x24(%eax),%edx
80105abf:	85 d2                	test   %edx,%edx
80105ac1:	74 11                	je     80105ad4 <trap+0xc4>
80105ac3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ac7:	83 e0 03             	and    $0x3,%eax
80105aca:	66 83 f8 03          	cmp    $0x3,%ax
80105ace:	0f 84 4c 01 00 00    	je     80105c20 <trap+0x210>
80105ad4:	e8 07 dd ff ff       	call   801037e0 <myproc>
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	74 0b                	je     80105ae8 <trap+0xd8>
80105add:	e8 fe dc ff ff       	call   801037e0 <myproc>
80105ae2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ae6:	74 68                	je     80105b50 <trap+0x140>
80105ae8:	e8 f3 dc ff ff       	call   801037e0 <myproc>
80105aed:	85 c0                	test   %eax,%eax
80105aef:	74 19                	je     80105b0a <trap+0xfa>
80105af1:	e8 ea dc ff ff       	call   801037e0 <myproc>
80105af6:	8b 40 24             	mov    0x24(%eax),%eax
80105af9:	85 c0                	test   %eax,%eax
80105afb:	74 0d                	je     80105b0a <trap+0xfa>
80105afd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b01:	83 e0 03             	and    $0x3,%eax
80105b04:	66 83 f8 03          	cmp    $0x3,%ax
80105b08:	74 37                	je     80105b41 <trap+0x131>
80105b0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b0d:	5b                   	pop    %ebx
80105b0e:	5e                   	pop    %esi
80105b0f:	5f                   	pop    %edi
80105b10:	5d                   	pop    %ebp
80105b11:	c3                   	ret    
80105b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b18:	e8 c3 dc ff ff       	call   801037e0 <myproc>
80105b1d:	8b 58 24             	mov    0x24(%eax),%ebx
80105b20:	85 db                	test   %ebx,%ebx
80105b22:	0f 85 e8 00 00 00    	jne    80105c10 <trap+0x200>
80105b28:	e8 b3 dc ff ff       	call   801037e0 <myproc>
80105b2d:	89 78 18             	mov    %edi,0x18(%eax)
80105b30:	e8 ab ef ff ff       	call   80104ae0 <syscall>
80105b35:	e8 a6 dc ff ff       	call   801037e0 <myproc>
80105b3a:	8b 48 24             	mov    0x24(%eax),%ecx
80105b3d:	85 c9                	test   %ecx,%ecx
80105b3f:	74 c9                	je     80105b0a <trap+0xfa>
80105b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b44:	5b                   	pop    %ebx
80105b45:	5e                   	pop    %esi
80105b46:	5f                   	pop    %edi
80105b47:	5d                   	pop    %ebp
80105b48:	e9 b3 e0 ff ff       	jmp    80103c00 <exit>
80105b4d:	8d 76 00             	lea    0x0(%esi),%esi
80105b50:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105b54:	75 92                	jne    80105ae8 <trap+0xd8>
80105b56:	e8 d5 e1 ff ff       	call   80103d30 <yield>
80105b5b:	eb 8b                	jmp    80105ae8 <trap+0xd8>
80105b5d:	8d 76 00             	lea    0x0(%esi),%esi
80105b60:	e8 5b dc ff ff       	call   801037c0 <cpuid>
80105b65:	85 c0                	test   %eax,%eax
80105b67:	0f 84 c3 00 00 00    	je     80105c30 <trap+0x220>
80105b6d:	e8 de cb ff ff       	call   80102750 <lapiceoi>
80105b72:	e8 69 dc ff ff       	call   801037e0 <myproc>
80105b77:	85 c0                	test   %eax,%eax
80105b79:	0f 85 38 ff ff ff    	jne    80105ab7 <trap+0xa7>
80105b7f:	e9 50 ff ff ff       	jmp    80105ad4 <trap+0xc4>
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b88:	e8 83 ca ff ff       	call   80102610 <kbdintr>
80105b8d:	e8 be cb ff ff       	call   80102750 <lapiceoi>
80105b92:	e8 49 dc ff ff       	call   801037e0 <myproc>
80105b97:	85 c0                	test   %eax,%eax
80105b99:	0f 85 18 ff ff ff    	jne    80105ab7 <trap+0xa7>
80105b9f:	e9 30 ff ff ff       	jmp    80105ad4 <trap+0xc4>
80105ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ba8:	e8 53 02 00 00       	call   80105e00 <uartintr>
80105bad:	e8 9e cb ff ff       	call   80102750 <lapiceoi>
80105bb2:	e8 29 dc ff ff       	call   801037e0 <myproc>
80105bb7:	85 c0                	test   %eax,%eax
80105bb9:	0f 85 f8 fe ff ff    	jne    80105ab7 <trap+0xa7>
80105bbf:	e9 10 ff ff ff       	jmp    80105ad4 <trap+0xc4>
80105bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bc8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105bcc:	8b 77 38             	mov    0x38(%edi),%esi
80105bcf:	e8 ec db ff ff       	call   801037c0 <cpuid>
80105bd4:	56                   	push   %esi
80105bd5:	53                   	push   %ebx
80105bd6:	50                   	push   %eax
80105bd7:	68 b0 7a 10 80       	push   $0x80107ab0
80105bdc:	e8 7f aa ff ff       	call   80100660 <cprintf>
80105be1:	e8 6a cb ff ff       	call   80102750 <lapiceoi>
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	e8 f2 db ff ff       	call   801037e0 <myproc>
80105bee:	85 c0                	test   %eax,%eax
80105bf0:	0f 85 c1 fe ff ff    	jne    80105ab7 <trap+0xa7>
80105bf6:	e9 d9 fe ff ff       	jmp    80105ad4 <trap+0xc4>
80105bfb:	90                   	nop
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c00:	e8 7b c4 ff ff       	call   80102080 <ideintr>
80105c05:	e9 63 ff ff ff       	jmp    80105b6d <trap+0x15d>
80105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c10:	e8 eb df ff ff       	call   80103c00 <exit>
80105c15:	e9 0e ff ff ff       	jmp    80105b28 <trap+0x118>
80105c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c20:	e8 db df ff ff       	call   80103c00 <exit>
80105c25:	e9 aa fe ff ff       	jmp    80105ad4 <trap+0xc4>
80105c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c30:	83 ec 0c             	sub    $0xc,%esp
80105c33:	68 80 4e 11 80       	push   $0x80114e80
80105c38:	e8 93 e9 ff ff       	call   801045d0 <acquire>
80105c3d:	c7 04 24 c0 56 11 80 	movl   $0x801156c0,(%esp)
80105c44:	83 05 c0 56 11 80 01 	addl   $0x1,0x801156c0
80105c4b:	e8 e0 e2 ff ff       	call   80103f30 <wakeup>
80105c50:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
80105c57:	e8 44 ea ff ff       	call   801046a0 <release>
80105c5c:	83 c4 10             	add    $0x10,%esp
80105c5f:	e9 09 ff ff ff       	jmp    80105b6d <trap+0x15d>
80105c64:	0f 20 d6             	mov    %cr2,%esi
80105c67:	e8 54 db ff ff       	call   801037c0 <cpuid>
80105c6c:	83 ec 0c             	sub    $0xc,%esp
80105c6f:	56                   	push   %esi
80105c70:	53                   	push   %ebx
80105c71:	50                   	push   %eax
80105c72:	ff 77 30             	pushl  0x30(%edi)
80105c75:	68 d4 7a 10 80       	push   $0x80107ad4
80105c7a:	e8 e1 a9 ff ff       	call   80100660 <cprintf>
80105c7f:	83 c4 14             	add    $0x14,%esp
80105c82:	68 aa 7a 10 80       	push   $0x80107aaa
80105c87:	e8 04 a7 ff ff       	call   80100390 <panic>
80105c8c:	66 90                	xchg   %ax,%ax
80105c8e:	66 90                	xchg   %ax,%ax

80105c90 <uartgetc>:
80105c90:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80105c95:	55                   	push   %ebp
80105c96:	89 e5                	mov    %esp,%ebp
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	74 1c                	je     80105cb8 <uartgetc+0x28>
80105c9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ca1:	ec                   	in     (%dx),%al
80105ca2:	a8 01                	test   $0x1,%al
80105ca4:	74 12                	je     80105cb8 <uartgetc+0x28>
80105ca6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cab:	ec                   	in     (%dx),%al
80105cac:	0f b6 c0             	movzbl %al,%eax
80105caf:	5d                   	pop    %ebp
80105cb0:	c3                   	ret    
80105cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cbd:	5d                   	pop    %ebp
80105cbe:	c3                   	ret    
80105cbf:	90                   	nop

80105cc0 <uartputc.part.0>:
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	57                   	push   %edi
80105cc4:	56                   	push   %esi
80105cc5:	53                   	push   %ebx
80105cc6:	89 c7                	mov    %eax,%edi
80105cc8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ccd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105cd2:	83 ec 0c             	sub    $0xc,%esp
80105cd5:	eb 1b                	jmp    80105cf2 <uartputc.part.0+0x32>
80105cd7:	89 f6                	mov    %esi,%esi
80105cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	6a 0a                	push   $0xa
80105ce5:	e8 86 ca ff ff       	call   80102770 <microdelay>
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	83 eb 01             	sub    $0x1,%ebx
80105cf0:	74 07                	je     80105cf9 <uartputc.part.0+0x39>
80105cf2:	89 f2                	mov    %esi,%edx
80105cf4:	ec                   	in     (%dx),%al
80105cf5:	a8 20                	test   $0x20,%al
80105cf7:	74 e7                	je     80105ce0 <uartputc.part.0+0x20>
80105cf9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cfe:	89 f8                	mov    %edi,%eax
80105d00:	ee                   	out    %al,(%dx)
80105d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d04:	5b                   	pop    %ebx
80105d05:	5e                   	pop    %esi
80105d06:	5f                   	pop    %edi
80105d07:	5d                   	pop    %ebp
80105d08:	c3                   	ret    
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d10 <uartinit>:
80105d10:	55                   	push   %ebp
80105d11:	31 c9                	xor    %ecx,%ecx
80105d13:	89 c8                	mov    %ecx,%eax
80105d15:	89 e5                	mov    %esp,%ebp
80105d17:	57                   	push   %edi
80105d18:	56                   	push   %esi
80105d19:	53                   	push   %ebx
80105d1a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d1f:	89 da                	mov    %ebx,%edx
80105d21:	83 ec 0c             	sub    $0xc,%esp
80105d24:	ee                   	out    %al,(%dx)
80105d25:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d2f:	89 fa                	mov    %edi,%edx
80105d31:	ee                   	out    %al,(%dx)
80105d32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d37:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d3c:	ee                   	out    %al,(%dx)
80105d3d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d42:	89 c8                	mov    %ecx,%eax
80105d44:	89 f2                	mov    %esi,%edx
80105d46:	ee                   	out    %al,(%dx)
80105d47:	b8 03 00 00 00       	mov    $0x3,%eax
80105d4c:	89 fa                	mov    %edi,%edx
80105d4e:	ee                   	out    %al,(%dx)
80105d4f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d54:	89 c8                	mov    %ecx,%eax
80105d56:	ee                   	out    %al,(%dx)
80105d57:	b8 01 00 00 00       	mov    $0x1,%eax
80105d5c:	89 f2                	mov    %esi,%edx
80105d5e:	ee                   	out    %al,(%dx)
80105d5f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d64:	ec                   	in     (%dx),%al
80105d65:	3c ff                	cmp    $0xff,%al
80105d67:	74 5a                	je     80105dc3 <uartinit+0xb3>
80105d69:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105d70:	00 00 00 
80105d73:	89 da                	mov    %ebx,%edx
80105d75:	ec                   	in     (%dx),%al
80105d76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d7b:	ec                   	in     (%dx),%al
80105d7c:	83 ec 08             	sub    $0x8,%esp
80105d7f:	bb cc 7b 10 80       	mov    $0x80107bcc,%ebx
80105d84:	6a 00                	push   $0x0
80105d86:	6a 04                	push   $0x4
80105d88:	e8 43 c5 ff ff       	call   801022d0 <ioapicenable>
80105d8d:	83 c4 10             	add    $0x10,%esp
80105d90:	b8 78 00 00 00       	mov    $0x78,%eax
80105d95:	eb 13                	jmp    80105daa <uartinit+0x9a>
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105da0:	83 c3 01             	add    $0x1,%ebx
80105da3:	0f be 03             	movsbl (%ebx),%eax
80105da6:	84 c0                	test   %al,%al
80105da8:	74 19                	je     80105dc3 <uartinit+0xb3>
80105daa:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105db0:	85 d2                	test   %edx,%edx
80105db2:	74 ec                	je     80105da0 <uartinit+0x90>
80105db4:	83 c3 01             	add    $0x1,%ebx
80105db7:	e8 04 ff ff ff       	call   80105cc0 <uartputc.part.0>
80105dbc:	0f be 03             	movsbl (%ebx),%eax
80105dbf:	84 c0                	test   %al,%al
80105dc1:	75 e7                	jne    80105daa <uartinit+0x9a>
80105dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc6:	5b                   	pop    %ebx
80105dc7:	5e                   	pop    %esi
80105dc8:	5f                   	pop    %edi
80105dc9:	5d                   	pop    %ebp
80105dca:	c3                   	ret    
80105dcb:	90                   	nop
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105dd0 <uartputc>:
80105dd0:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105dd6:	55                   	push   %ebp
80105dd7:	89 e5                	mov    %esp,%ebp
80105dd9:	85 d2                	test   %edx,%edx
80105ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80105dde:	74 10                	je     80105df0 <uartputc+0x20>
80105de0:	5d                   	pop    %ebp
80105de1:	e9 da fe ff ff       	jmp    80105cc0 <uartputc.part.0>
80105de6:	8d 76 00             	lea    0x0(%esi),%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105df0:	5d                   	pop    %ebp
80105df1:	c3                   	ret    
80105df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e00 <uartintr>:
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	83 ec 14             	sub    $0x14,%esp
80105e06:	68 90 5c 10 80       	push   $0x80105c90
80105e0b:	e8 00 aa ff ff       	call   80100810 <consoleintr>
80105e10:	83 c4 10             	add    $0x10,%esp
80105e13:	c9                   	leave  
80105e14:	c3                   	ret    

80105e15 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e15:	6a 00                	push   $0x0
  pushl $0
80105e17:	6a 00                	push   $0x0
  jmp alltraps
80105e19:	e9 11 fb ff ff       	jmp    8010592f <alltraps>

80105e1e <vector1>:
.globl vector1
vector1:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $1
80105e20:	6a 01                	push   $0x1
  jmp alltraps
80105e22:	e9 08 fb ff ff       	jmp    8010592f <alltraps>

80105e27 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $2
80105e29:	6a 02                	push   $0x2
  jmp alltraps
80105e2b:	e9 ff fa ff ff       	jmp    8010592f <alltraps>

80105e30 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $3
80105e32:	6a 03                	push   $0x3
  jmp alltraps
80105e34:	e9 f6 fa ff ff       	jmp    8010592f <alltraps>

80105e39 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $4
80105e3b:	6a 04                	push   $0x4
  jmp alltraps
80105e3d:	e9 ed fa ff ff       	jmp    8010592f <alltraps>

80105e42 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $5
80105e44:	6a 05                	push   $0x5
  jmp alltraps
80105e46:	e9 e4 fa ff ff       	jmp    8010592f <alltraps>

80105e4b <vector6>:
.globl vector6
vector6:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $6
80105e4d:	6a 06                	push   $0x6
  jmp alltraps
80105e4f:	e9 db fa ff ff       	jmp    8010592f <alltraps>

80105e54 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $7
80105e56:	6a 07                	push   $0x7
  jmp alltraps
80105e58:	e9 d2 fa ff ff       	jmp    8010592f <alltraps>

80105e5d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e5d:	6a 08                	push   $0x8
  jmp alltraps
80105e5f:	e9 cb fa ff ff       	jmp    8010592f <alltraps>

80105e64 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $9
80105e66:	6a 09                	push   $0x9
  jmp alltraps
80105e68:	e9 c2 fa ff ff       	jmp    8010592f <alltraps>

80105e6d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e6d:	6a 0a                	push   $0xa
  jmp alltraps
80105e6f:	e9 bb fa ff ff       	jmp    8010592f <alltraps>

80105e74 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e74:	6a 0b                	push   $0xb
  jmp alltraps
80105e76:	e9 b4 fa ff ff       	jmp    8010592f <alltraps>

80105e7b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e7b:	6a 0c                	push   $0xc
  jmp alltraps
80105e7d:	e9 ad fa ff ff       	jmp    8010592f <alltraps>

80105e82 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e82:	6a 0d                	push   $0xd
  jmp alltraps
80105e84:	e9 a6 fa ff ff       	jmp    8010592f <alltraps>

80105e89 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e89:	6a 0e                	push   $0xe
  jmp alltraps
80105e8b:	e9 9f fa ff ff       	jmp    8010592f <alltraps>

80105e90 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $15
80105e92:	6a 0f                	push   $0xf
  jmp alltraps
80105e94:	e9 96 fa ff ff       	jmp    8010592f <alltraps>

80105e99 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $16
80105e9b:	6a 10                	push   $0x10
  jmp alltraps
80105e9d:	e9 8d fa ff ff       	jmp    8010592f <alltraps>

80105ea2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ea2:	6a 11                	push   $0x11
  jmp alltraps
80105ea4:	e9 86 fa ff ff       	jmp    8010592f <alltraps>

80105ea9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $18
80105eab:	6a 12                	push   $0x12
  jmp alltraps
80105ead:	e9 7d fa ff ff       	jmp    8010592f <alltraps>

80105eb2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $19
80105eb4:	6a 13                	push   $0x13
  jmp alltraps
80105eb6:	e9 74 fa ff ff       	jmp    8010592f <alltraps>

80105ebb <vector20>:
.globl vector20
vector20:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $20
80105ebd:	6a 14                	push   $0x14
  jmp alltraps
80105ebf:	e9 6b fa ff ff       	jmp    8010592f <alltraps>

80105ec4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $21
80105ec6:	6a 15                	push   $0x15
  jmp alltraps
80105ec8:	e9 62 fa ff ff       	jmp    8010592f <alltraps>

80105ecd <vector22>:
.globl vector22
vector22:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $22
80105ecf:	6a 16                	push   $0x16
  jmp alltraps
80105ed1:	e9 59 fa ff ff       	jmp    8010592f <alltraps>

80105ed6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $23
80105ed8:	6a 17                	push   $0x17
  jmp alltraps
80105eda:	e9 50 fa ff ff       	jmp    8010592f <alltraps>

80105edf <vector24>:
.globl vector24
vector24:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $24
80105ee1:	6a 18                	push   $0x18
  jmp alltraps
80105ee3:	e9 47 fa ff ff       	jmp    8010592f <alltraps>

80105ee8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $25
80105eea:	6a 19                	push   $0x19
  jmp alltraps
80105eec:	e9 3e fa ff ff       	jmp    8010592f <alltraps>

80105ef1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $26
80105ef3:	6a 1a                	push   $0x1a
  jmp alltraps
80105ef5:	e9 35 fa ff ff       	jmp    8010592f <alltraps>

80105efa <vector27>:
.globl vector27
vector27:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $27
80105efc:	6a 1b                	push   $0x1b
  jmp alltraps
80105efe:	e9 2c fa ff ff       	jmp    8010592f <alltraps>

80105f03 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $28
80105f05:	6a 1c                	push   $0x1c
  jmp alltraps
80105f07:	e9 23 fa ff ff       	jmp    8010592f <alltraps>

80105f0c <vector29>:
.globl vector29
vector29:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $29
80105f0e:	6a 1d                	push   $0x1d
  jmp alltraps
80105f10:	e9 1a fa ff ff       	jmp    8010592f <alltraps>

80105f15 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $30
80105f17:	6a 1e                	push   $0x1e
  jmp alltraps
80105f19:	e9 11 fa ff ff       	jmp    8010592f <alltraps>

80105f1e <vector31>:
.globl vector31
vector31:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $31
80105f20:	6a 1f                	push   $0x1f
  jmp alltraps
80105f22:	e9 08 fa ff ff       	jmp    8010592f <alltraps>

80105f27 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $32
80105f29:	6a 20                	push   $0x20
  jmp alltraps
80105f2b:	e9 ff f9 ff ff       	jmp    8010592f <alltraps>

80105f30 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $33
80105f32:	6a 21                	push   $0x21
  jmp alltraps
80105f34:	e9 f6 f9 ff ff       	jmp    8010592f <alltraps>

80105f39 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $34
80105f3b:	6a 22                	push   $0x22
  jmp alltraps
80105f3d:	e9 ed f9 ff ff       	jmp    8010592f <alltraps>

80105f42 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $35
80105f44:	6a 23                	push   $0x23
  jmp alltraps
80105f46:	e9 e4 f9 ff ff       	jmp    8010592f <alltraps>

80105f4b <vector36>:
.globl vector36
vector36:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $36
80105f4d:	6a 24                	push   $0x24
  jmp alltraps
80105f4f:	e9 db f9 ff ff       	jmp    8010592f <alltraps>

80105f54 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $37
80105f56:	6a 25                	push   $0x25
  jmp alltraps
80105f58:	e9 d2 f9 ff ff       	jmp    8010592f <alltraps>

80105f5d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $38
80105f5f:	6a 26                	push   $0x26
  jmp alltraps
80105f61:	e9 c9 f9 ff ff       	jmp    8010592f <alltraps>

80105f66 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $39
80105f68:	6a 27                	push   $0x27
  jmp alltraps
80105f6a:	e9 c0 f9 ff ff       	jmp    8010592f <alltraps>

80105f6f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $40
80105f71:	6a 28                	push   $0x28
  jmp alltraps
80105f73:	e9 b7 f9 ff ff       	jmp    8010592f <alltraps>

80105f78 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $41
80105f7a:	6a 29                	push   $0x29
  jmp alltraps
80105f7c:	e9 ae f9 ff ff       	jmp    8010592f <alltraps>

80105f81 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $42
80105f83:	6a 2a                	push   $0x2a
  jmp alltraps
80105f85:	e9 a5 f9 ff ff       	jmp    8010592f <alltraps>

80105f8a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $43
80105f8c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f8e:	e9 9c f9 ff ff       	jmp    8010592f <alltraps>

80105f93 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $44
80105f95:	6a 2c                	push   $0x2c
  jmp alltraps
80105f97:	e9 93 f9 ff ff       	jmp    8010592f <alltraps>

80105f9c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $45
80105f9e:	6a 2d                	push   $0x2d
  jmp alltraps
80105fa0:	e9 8a f9 ff ff       	jmp    8010592f <alltraps>

80105fa5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $46
80105fa7:	6a 2e                	push   $0x2e
  jmp alltraps
80105fa9:	e9 81 f9 ff ff       	jmp    8010592f <alltraps>

80105fae <vector47>:
.globl vector47
vector47:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $47
80105fb0:	6a 2f                	push   $0x2f
  jmp alltraps
80105fb2:	e9 78 f9 ff ff       	jmp    8010592f <alltraps>

80105fb7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $48
80105fb9:	6a 30                	push   $0x30
  jmp alltraps
80105fbb:	e9 6f f9 ff ff       	jmp    8010592f <alltraps>

80105fc0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $49
80105fc2:	6a 31                	push   $0x31
  jmp alltraps
80105fc4:	e9 66 f9 ff ff       	jmp    8010592f <alltraps>

80105fc9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $50
80105fcb:	6a 32                	push   $0x32
  jmp alltraps
80105fcd:	e9 5d f9 ff ff       	jmp    8010592f <alltraps>

80105fd2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $51
80105fd4:	6a 33                	push   $0x33
  jmp alltraps
80105fd6:	e9 54 f9 ff ff       	jmp    8010592f <alltraps>

80105fdb <vector52>:
.globl vector52
vector52:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $52
80105fdd:	6a 34                	push   $0x34
  jmp alltraps
80105fdf:	e9 4b f9 ff ff       	jmp    8010592f <alltraps>

80105fe4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $53
80105fe6:	6a 35                	push   $0x35
  jmp alltraps
80105fe8:	e9 42 f9 ff ff       	jmp    8010592f <alltraps>

80105fed <vector54>:
.globl vector54
vector54:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $54
80105fef:	6a 36                	push   $0x36
  jmp alltraps
80105ff1:	e9 39 f9 ff ff       	jmp    8010592f <alltraps>

80105ff6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $55
80105ff8:	6a 37                	push   $0x37
  jmp alltraps
80105ffa:	e9 30 f9 ff ff       	jmp    8010592f <alltraps>

80105fff <vector56>:
.globl vector56
vector56:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $56
80106001:	6a 38                	push   $0x38
  jmp alltraps
80106003:	e9 27 f9 ff ff       	jmp    8010592f <alltraps>

80106008 <vector57>:
.globl vector57
vector57:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $57
8010600a:	6a 39                	push   $0x39
  jmp alltraps
8010600c:	e9 1e f9 ff ff       	jmp    8010592f <alltraps>

80106011 <vector58>:
.globl vector58
vector58:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $58
80106013:	6a 3a                	push   $0x3a
  jmp alltraps
80106015:	e9 15 f9 ff ff       	jmp    8010592f <alltraps>

8010601a <vector59>:
.globl vector59
vector59:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $59
8010601c:	6a 3b                	push   $0x3b
  jmp alltraps
8010601e:	e9 0c f9 ff ff       	jmp    8010592f <alltraps>

80106023 <vector60>:
.globl vector60
vector60:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $60
80106025:	6a 3c                	push   $0x3c
  jmp alltraps
80106027:	e9 03 f9 ff ff       	jmp    8010592f <alltraps>

8010602c <vector61>:
.globl vector61
vector61:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $61
8010602e:	6a 3d                	push   $0x3d
  jmp alltraps
80106030:	e9 fa f8 ff ff       	jmp    8010592f <alltraps>

80106035 <vector62>:
.globl vector62
vector62:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $62
80106037:	6a 3e                	push   $0x3e
  jmp alltraps
80106039:	e9 f1 f8 ff ff       	jmp    8010592f <alltraps>

8010603e <vector63>:
.globl vector63
vector63:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $63
80106040:	6a 3f                	push   $0x3f
  jmp alltraps
80106042:	e9 e8 f8 ff ff       	jmp    8010592f <alltraps>

80106047 <vector64>:
.globl vector64
vector64:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $64
80106049:	6a 40                	push   $0x40
  jmp alltraps
8010604b:	e9 df f8 ff ff       	jmp    8010592f <alltraps>

80106050 <vector65>:
.globl vector65
vector65:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $65
80106052:	6a 41                	push   $0x41
  jmp alltraps
80106054:	e9 d6 f8 ff ff       	jmp    8010592f <alltraps>

80106059 <vector66>:
.globl vector66
vector66:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $66
8010605b:	6a 42                	push   $0x42
  jmp alltraps
8010605d:	e9 cd f8 ff ff       	jmp    8010592f <alltraps>

80106062 <vector67>:
.globl vector67
vector67:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $67
80106064:	6a 43                	push   $0x43
  jmp alltraps
80106066:	e9 c4 f8 ff ff       	jmp    8010592f <alltraps>

8010606b <vector68>:
.globl vector68
vector68:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $68
8010606d:	6a 44                	push   $0x44
  jmp alltraps
8010606f:	e9 bb f8 ff ff       	jmp    8010592f <alltraps>

80106074 <vector69>:
.globl vector69
vector69:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $69
80106076:	6a 45                	push   $0x45
  jmp alltraps
80106078:	e9 b2 f8 ff ff       	jmp    8010592f <alltraps>

8010607d <vector70>:
.globl vector70
vector70:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $70
8010607f:	6a 46                	push   $0x46
  jmp alltraps
80106081:	e9 a9 f8 ff ff       	jmp    8010592f <alltraps>

80106086 <vector71>:
.globl vector71
vector71:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $71
80106088:	6a 47                	push   $0x47
  jmp alltraps
8010608a:	e9 a0 f8 ff ff       	jmp    8010592f <alltraps>

8010608f <vector72>:
.globl vector72
vector72:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $72
80106091:	6a 48                	push   $0x48
  jmp alltraps
80106093:	e9 97 f8 ff ff       	jmp    8010592f <alltraps>

80106098 <vector73>:
.globl vector73
vector73:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $73
8010609a:	6a 49                	push   $0x49
  jmp alltraps
8010609c:	e9 8e f8 ff ff       	jmp    8010592f <alltraps>

801060a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $74
801060a3:	6a 4a                	push   $0x4a
  jmp alltraps
801060a5:	e9 85 f8 ff ff       	jmp    8010592f <alltraps>

801060aa <vector75>:
.globl vector75
vector75:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $75
801060ac:	6a 4b                	push   $0x4b
  jmp alltraps
801060ae:	e9 7c f8 ff ff       	jmp    8010592f <alltraps>

801060b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $76
801060b5:	6a 4c                	push   $0x4c
  jmp alltraps
801060b7:	e9 73 f8 ff ff       	jmp    8010592f <alltraps>

801060bc <vector77>:
.globl vector77
vector77:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $77
801060be:	6a 4d                	push   $0x4d
  jmp alltraps
801060c0:	e9 6a f8 ff ff       	jmp    8010592f <alltraps>

801060c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $78
801060c7:	6a 4e                	push   $0x4e
  jmp alltraps
801060c9:	e9 61 f8 ff ff       	jmp    8010592f <alltraps>

801060ce <vector79>:
.globl vector79
vector79:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $79
801060d0:	6a 4f                	push   $0x4f
  jmp alltraps
801060d2:	e9 58 f8 ff ff       	jmp    8010592f <alltraps>

801060d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $80
801060d9:	6a 50                	push   $0x50
  jmp alltraps
801060db:	e9 4f f8 ff ff       	jmp    8010592f <alltraps>

801060e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $81
801060e2:	6a 51                	push   $0x51
  jmp alltraps
801060e4:	e9 46 f8 ff ff       	jmp    8010592f <alltraps>

801060e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $82
801060eb:	6a 52                	push   $0x52
  jmp alltraps
801060ed:	e9 3d f8 ff ff       	jmp    8010592f <alltraps>

801060f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $83
801060f4:	6a 53                	push   $0x53
  jmp alltraps
801060f6:	e9 34 f8 ff ff       	jmp    8010592f <alltraps>

801060fb <vector84>:
.globl vector84
vector84:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $84
801060fd:	6a 54                	push   $0x54
  jmp alltraps
801060ff:	e9 2b f8 ff ff       	jmp    8010592f <alltraps>

80106104 <vector85>:
.globl vector85
vector85:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $85
80106106:	6a 55                	push   $0x55
  jmp alltraps
80106108:	e9 22 f8 ff ff       	jmp    8010592f <alltraps>

8010610d <vector86>:
.globl vector86
vector86:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $86
8010610f:	6a 56                	push   $0x56
  jmp alltraps
80106111:	e9 19 f8 ff ff       	jmp    8010592f <alltraps>

80106116 <vector87>:
.globl vector87
vector87:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $87
80106118:	6a 57                	push   $0x57
  jmp alltraps
8010611a:	e9 10 f8 ff ff       	jmp    8010592f <alltraps>

8010611f <vector88>:
.globl vector88
vector88:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $88
80106121:	6a 58                	push   $0x58
  jmp alltraps
80106123:	e9 07 f8 ff ff       	jmp    8010592f <alltraps>

80106128 <vector89>:
.globl vector89
vector89:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $89
8010612a:	6a 59                	push   $0x59
  jmp alltraps
8010612c:	e9 fe f7 ff ff       	jmp    8010592f <alltraps>

80106131 <vector90>:
.globl vector90
vector90:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $90
80106133:	6a 5a                	push   $0x5a
  jmp alltraps
80106135:	e9 f5 f7 ff ff       	jmp    8010592f <alltraps>

8010613a <vector91>:
.globl vector91
vector91:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $91
8010613c:	6a 5b                	push   $0x5b
  jmp alltraps
8010613e:	e9 ec f7 ff ff       	jmp    8010592f <alltraps>

80106143 <vector92>:
.globl vector92
vector92:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $92
80106145:	6a 5c                	push   $0x5c
  jmp alltraps
80106147:	e9 e3 f7 ff ff       	jmp    8010592f <alltraps>

8010614c <vector93>:
.globl vector93
vector93:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $93
8010614e:	6a 5d                	push   $0x5d
  jmp alltraps
80106150:	e9 da f7 ff ff       	jmp    8010592f <alltraps>

80106155 <vector94>:
.globl vector94
vector94:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $94
80106157:	6a 5e                	push   $0x5e
  jmp alltraps
80106159:	e9 d1 f7 ff ff       	jmp    8010592f <alltraps>

8010615e <vector95>:
.globl vector95
vector95:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $95
80106160:	6a 5f                	push   $0x5f
  jmp alltraps
80106162:	e9 c8 f7 ff ff       	jmp    8010592f <alltraps>

80106167 <vector96>:
.globl vector96
vector96:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $96
80106169:	6a 60                	push   $0x60
  jmp alltraps
8010616b:	e9 bf f7 ff ff       	jmp    8010592f <alltraps>

80106170 <vector97>:
.globl vector97
vector97:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $97
80106172:	6a 61                	push   $0x61
  jmp alltraps
80106174:	e9 b6 f7 ff ff       	jmp    8010592f <alltraps>

80106179 <vector98>:
.globl vector98
vector98:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $98
8010617b:	6a 62                	push   $0x62
  jmp alltraps
8010617d:	e9 ad f7 ff ff       	jmp    8010592f <alltraps>

80106182 <vector99>:
.globl vector99
vector99:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $99
80106184:	6a 63                	push   $0x63
  jmp alltraps
80106186:	e9 a4 f7 ff ff       	jmp    8010592f <alltraps>

8010618b <vector100>:
.globl vector100
vector100:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $100
8010618d:	6a 64                	push   $0x64
  jmp alltraps
8010618f:	e9 9b f7 ff ff       	jmp    8010592f <alltraps>

80106194 <vector101>:
.globl vector101
vector101:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $101
80106196:	6a 65                	push   $0x65
  jmp alltraps
80106198:	e9 92 f7 ff ff       	jmp    8010592f <alltraps>

8010619d <vector102>:
.globl vector102
vector102:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $102
8010619f:	6a 66                	push   $0x66
  jmp alltraps
801061a1:	e9 89 f7 ff ff       	jmp    8010592f <alltraps>

801061a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $103
801061a8:	6a 67                	push   $0x67
  jmp alltraps
801061aa:	e9 80 f7 ff ff       	jmp    8010592f <alltraps>

801061af <vector104>:
.globl vector104
vector104:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $104
801061b1:	6a 68                	push   $0x68
  jmp alltraps
801061b3:	e9 77 f7 ff ff       	jmp    8010592f <alltraps>

801061b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $105
801061ba:	6a 69                	push   $0x69
  jmp alltraps
801061bc:	e9 6e f7 ff ff       	jmp    8010592f <alltraps>

801061c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $106
801061c3:	6a 6a                	push   $0x6a
  jmp alltraps
801061c5:	e9 65 f7 ff ff       	jmp    8010592f <alltraps>

801061ca <vector107>:
.globl vector107
vector107:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $107
801061cc:	6a 6b                	push   $0x6b
  jmp alltraps
801061ce:	e9 5c f7 ff ff       	jmp    8010592f <alltraps>

801061d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $108
801061d5:	6a 6c                	push   $0x6c
  jmp alltraps
801061d7:	e9 53 f7 ff ff       	jmp    8010592f <alltraps>

801061dc <vector109>:
.globl vector109
vector109:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $109
801061de:	6a 6d                	push   $0x6d
  jmp alltraps
801061e0:	e9 4a f7 ff ff       	jmp    8010592f <alltraps>

801061e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $110
801061e7:	6a 6e                	push   $0x6e
  jmp alltraps
801061e9:	e9 41 f7 ff ff       	jmp    8010592f <alltraps>

801061ee <vector111>:
.globl vector111
vector111:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $111
801061f0:	6a 6f                	push   $0x6f
  jmp alltraps
801061f2:	e9 38 f7 ff ff       	jmp    8010592f <alltraps>

801061f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $112
801061f9:	6a 70                	push   $0x70
  jmp alltraps
801061fb:	e9 2f f7 ff ff       	jmp    8010592f <alltraps>

80106200 <vector113>:
.globl vector113
vector113:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $113
80106202:	6a 71                	push   $0x71
  jmp alltraps
80106204:	e9 26 f7 ff ff       	jmp    8010592f <alltraps>

80106209 <vector114>:
.globl vector114
vector114:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $114
8010620b:	6a 72                	push   $0x72
  jmp alltraps
8010620d:	e9 1d f7 ff ff       	jmp    8010592f <alltraps>

80106212 <vector115>:
.globl vector115
vector115:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $115
80106214:	6a 73                	push   $0x73
  jmp alltraps
80106216:	e9 14 f7 ff ff       	jmp    8010592f <alltraps>

8010621b <vector116>:
.globl vector116
vector116:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $116
8010621d:	6a 74                	push   $0x74
  jmp alltraps
8010621f:	e9 0b f7 ff ff       	jmp    8010592f <alltraps>

80106224 <vector117>:
.globl vector117
vector117:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $117
80106226:	6a 75                	push   $0x75
  jmp alltraps
80106228:	e9 02 f7 ff ff       	jmp    8010592f <alltraps>

8010622d <vector118>:
.globl vector118
vector118:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $118
8010622f:	6a 76                	push   $0x76
  jmp alltraps
80106231:	e9 f9 f6 ff ff       	jmp    8010592f <alltraps>

80106236 <vector119>:
.globl vector119
vector119:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $119
80106238:	6a 77                	push   $0x77
  jmp alltraps
8010623a:	e9 f0 f6 ff ff       	jmp    8010592f <alltraps>

8010623f <vector120>:
.globl vector120
vector120:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $120
80106241:	6a 78                	push   $0x78
  jmp alltraps
80106243:	e9 e7 f6 ff ff       	jmp    8010592f <alltraps>

80106248 <vector121>:
.globl vector121
vector121:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $121
8010624a:	6a 79                	push   $0x79
  jmp alltraps
8010624c:	e9 de f6 ff ff       	jmp    8010592f <alltraps>

80106251 <vector122>:
.globl vector122
vector122:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $122
80106253:	6a 7a                	push   $0x7a
  jmp alltraps
80106255:	e9 d5 f6 ff ff       	jmp    8010592f <alltraps>

8010625a <vector123>:
.globl vector123
vector123:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $123
8010625c:	6a 7b                	push   $0x7b
  jmp alltraps
8010625e:	e9 cc f6 ff ff       	jmp    8010592f <alltraps>

80106263 <vector124>:
.globl vector124
vector124:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $124
80106265:	6a 7c                	push   $0x7c
  jmp alltraps
80106267:	e9 c3 f6 ff ff       	jmp    8010592f <alltraps>

8010626c <vector125>:
.globl vector125
vector125:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $125
8010626e:	6a 7d                	push   $0x7d
  jmp alltraps
80106270:	e9 ba f6 ff ff       	jmp    8010592f <alltraps>

80106275 <vector126>:
.globl vector126
vector126:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $126
80106277:	6a 7e                	push   $0x7e
  jmp alltraps
80106279:	e9 b1 f6 ff ff       	jmp    8010592f <alltraps>

8010627e <vector127>:
.globl vector127
vector127:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $127
80106280:	6a 7f                	push   $0x7f
  jmp alltraps
80106282:	e9 a8 f6 ff ff       	jmp    8010592f <alltraps>

80106287 <vector128>:
.globl vector128
vector128:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $128
80106289:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010628e:	e9 9c f6 ff ff       	jmp    8010592f <alltraps>

80106293 <vector129>:
.globl vector129
vector129:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $129
80106295:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010629a:	e9 90 f6 ff ff       	jmp    8010592f <alltraps>

8010629f <vector130>:
.globl vector130
vector130:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $130
801062a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801062a6:	e9 84 f6 ff ff       	jmp    8010592f <alltraps>

801062ab <vector131>:
.globl vector131
vector131:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $131
801062ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062b2:	e9 78 f6 ff ff       	jmp    8010592f <alltraps>

801062b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $132
801062b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062be:	e9 6c f6 ff ff       	jmp    8010592f <alltraps>

801062c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $133
801062c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062ca:	e9 60 f6 ff ff       	jmp    8010592f <alltraps>

801062cf <vector134>:
.globl vector134
vector134:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $134
801062d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062d6:	e9 54 f6 ff ff       	jmp    8010592f <alltraps>

801062db <vector135>:
.globl vector135
vector135:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $135
801062dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062e2:	e9 48 f6 ff ff       	jmp    8010592f <alltraps>

801062e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $136
801062e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801062ee:	e9 3c f6 ff ff       	jmp    8010592f <alltraps>

801062f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $137
801062f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062fa:	e9 30 f6 ff ff       	jmp    8010592f <alltraps>

801062ff <vector138>:
.globl vector138
vector138:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $138
80106301:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106306:	e9 24 f6 ff ff       	jmp    8010592f <alltraps>

8010630b <vector139>:
.globl vector139
vector139:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $139
8010630d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106312:	e9 18 f6 ff ff       	jmp    8010592f <alltraps>

80106317 <vector140>:
.globl vector140
vector140:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $140
80106319:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010631e:	e9 0c f6 ff ff       	jmp    8010592f <alltraps>

80106323 <vector141>:
.globl vector141
vector141:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $141
80106325:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010632a:	e9 00 f6 ff ff       	jmp    8010592f <alltraps>

8010632f <vector142>:
.globl vector142
vector142:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $142
80106331:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106336:	e9 f4 f5 ff ff       	jmp    8010592f <alltraps>

8010633b <vector143>:
.globl vector143
vector143:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $143
8010633d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106342:	e9 e8 f5 ff ff       	jmp    8010592f <alltraps>

80106347 <vector144>:
.globl vector144
vector144:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $144
80106349:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010634e:	e9 dc f5 ff ff       	jmp    8010592f <alltraps>

80106353 <vector145>:
.globl vector145
vector145:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $145
80106355:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010635a:	e9 d0 f5 ff ff       	jmp    8010592f <alltraps>

8010635f <vector146>:
.globl vector146
vector146:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $146
80106361:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106366:	e9 c4 f5 ff ff       	jmp    8010592f <alltraps>

8010636b <vector147>:
.globl vector147
vector147:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $147
8010636d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106372:	e9 b8 f5 ff ff       	jmp    8010592f <alltraps>

80106377 <vector148>:
.globl vector148
vector148:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $148
80106379:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010637e:	e9 ac f5 ff ff       	jmp    8010592f <alltraps>

80106383 <vector149>:
.globl vector149
vector149:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $149
80106385:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010638a:	e9 a0 f5 ff ff       	jmp    8010592f <alltraps>

8010638f <vector150>:
.globl vector150
vector150:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $150
80106391:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106396:	e9 94 f5 ff ff       	jmp    8010592f <alltraps>

8010639b <vector151>:
.globl vector151
vector151:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $151
8010639d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801063a2:	e9 88 f5 ff ff       	jmp    8010592f <alltraps>

801063a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $152
801063a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801063ae:	e9 7c f5 ff ff       	jmp    8010592f <alltraps>

801063b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $153
801063b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063ba:	e9 70 f5 ff ff       	jmp    8010592f <alltraps>

801063bf <vector154>:
.globl vector154
vector154:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $154
801063c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063c6:	e9 64 f5 ff ff       	jmp    8010592f <alltraps>

801063cb <vector155>:
.globl vector155
vector155:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $155
801063cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063d2:	e9 58 f5 ff ff       	jmp    8010592f <alltraps>

801063d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $156
801063d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063de:	e9 4c f5 ff ff       	jmp    8010592f <alltraps>

801063e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $157
801063e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063ea:	e9 40 f5 ff ff       	jmp    8010592f <alltraps>

801063ef <vector158>:
.globl vector158
vector158:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $158
801063f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063f6:	e9 34 f5 ff ff       	jmp    8010592f <alltraps>

801063fb <vector159>:
.globl vector159
vector159:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $159
801063fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106402:	e9 28 f5 ff ff       	jmp    8010592f <alltraps>

80106407 <vector160>:
.globl vector160
vector160:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $160
80106409:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010640e:	e9 1c f5 ff ff       	jmp    8010592f <alltraps>

80106413 <vector161>:
.globl vector161
vector161:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $161
80106415:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010641a:	e9 10 f5 ff ff       	jmp    8010592f <alltraps>

8010641f <vector162>:
.globl vector162
vector162:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $162
80106421:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106426:	e9 04 f5 ff ff       	jmp    8010592f <alltraps>

8010642b <vector163>:
.globl vector163
vector163:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $163
8010642d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106432:	e9 f8 f4 ff ff       	jmp    8010592f <alltraps>

80106437 <vector164>:
.globl vector164
vector164:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $164
80106439:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010643e:	e9 ec f4 ff ff       	jmp    8010592f <alltraps>

80106443 <vector165>:
.globl vector165
vector165:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $165
80106445:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010644a:	e9 e0 f4 ff ff       	jmp    8010592f <alltraps>

8010644f <vector166>:
.globl vector166
vector166:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $166
80106451:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106456:	e9 d4 f4 ff ff       	jmp    8010592f <alltraps>

8010645b <vector167>:
.globl vector167
vector167:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $167
8010645d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106462:	e9 c8 f4 ff ff       	jmp    8010592f <alltraps>

80106467 <vector168>:
.globl vector168
vector168:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $168
80106469:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010646e:	e9 bc f4 ff ff       	jmp    8010592f <alltraps>

80106473 <vector169>:
.globl vector169
vector169:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $169
80106475:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010647a:	e9 b0 f4 ff ff       	jmp    8010592f <alltraps>

8010647f <vector170>:
.globl vector170
vector170:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $170
80106481:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106486:	e9 a4 f4 ff ff       	jmp    8010592f <alltraps>

8010648b <vector171>:
.globl vector171
vector171:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $171
8010648d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106492:	e9 98 f4 ff ff       	jmp    8010592f <alltraps>

80106497 <vector172>:
.globl vector172
vector172:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $172
80106499:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010649e:	e9 8c f4 ff ff       	jmp    8010592f <alltraps>

801064a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $173
801064a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801064aa:	e9 80 f4 ff ff       	jmp    8010592f <alltraps>

801064af <vector174>:
.globl vector174
vector174:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $174
801064b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064b6:	e9 74 f4 ff ff       	jmp    8010592f <alltraps>

801064bb <vector175>:
.globl vector175
vector175:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $175
801064bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064c2:	e9 68 f4 ff ff       	jmp    8010592f <alltraps>

801064c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $176
801064c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064ce:	e9 5c f4 ff ff       	jmp    8010592f <alltraps>

801064d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $177
801064d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064da:	e9 50 f4 ff ff       	jmp    8010592f <alltraps>

801064df <vector178>:
.globl vector178
vector178:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $178
801064e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064e6:	e9 44 f4 ff ff       	jmp    8010592f <alltraps>

801064eb <vector179>:
.globl vector179
vector179:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $179
801064ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064f2:	e9 38 f4 ff ff       	jmp    8010592f <alltraps>

801064f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $180
801064f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064fe:	e9 2c f4 ff ff       	jmp    8010592f <alltraps>

80106503 <vector181>:
.globl vector181
vector181:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $181
80106505:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010650a:	e9 20 f4 ff ff       	jmp    8010592f <alltraps>

8010650f <vector182>:
.globl vector182
vector182:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $182
80106511:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106516:	e9 14 f4 ff ff       	jmp    8010592f <alltraps>

8010651b <vector183>:
.globl vector183
vector183:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $183
8010651d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106522:	e9 08 f4 ff ff       	jmp    8010592f <alltraps>

80106527 <vector184>:
.globl vector184
vector184:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $184
80106529:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010652e:	e9 fc f3 ff ff       	jmp    8010592f <alltraps>

80106533 <vector185>:
.globl vector185
vector185:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $185
80106535:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010653a:	e9 f0 f3 ff ff       	jmp    8010592f <alltraps>

8010653f <vector186>:
.globl vector186
vector186:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $186
80106541:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106546:	e9 e4 f3 ff ff       	jmp    8010592f <alltraps>

8010654b <vector187>:
.globl vector187
vector187:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $187
8010654d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106552:	e9 d8 f3 ff ff       	jmp    8010592f <alltraps>

80106557 <vector188>:
.globl vector188
vector188:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $188
80106559:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010655e:	e9 cc f3 ff ff       	jmp    8010592f <alltraps>

80106563 <vector189>:
.globl vector189
vector189:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $189
80106565:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010656a:	e9 c0 f3 ff ff       	jmp    8010592f <alltraps>

8010656f <vector190>:
.globl vector190
vector190:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $190
80106571:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106576:	e9 b4 f3 ff ff       	jmp    8010592f <alltraps>

8010657b <vector191>:
.globl vector191
vector191:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $191
8010657d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106582:	e9 a8 f3 ff ff       	jmp    8010592f <alltraps>

80106587 <vector192>:
.globl vector192
vector192:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $192
80106589:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010658e:	e9 9c f3 ff ff       	jmp    8010592f <alltraps>

80106593 <vector193>:
.globl vector193
vector193:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $193
80106595:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010659a:	e9 90 f3 ff ff       	jmp    8010592f <alltraps>

8010659f <vector194>:
.globl vector194
vector194:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $194
801065a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801065a6:	e9 84 f3 ff ff       	jmp    8010592f <alltraps>

801065ab <vector195>:
.globl vector195
vector195:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $195
801065ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065b2:	e9 78 f3 ff ff       	jmp    8010592f <alltraps>

801065b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $196
801065b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065be:	e9 6c f3 ff ff       	jmp    8010592f <alltraps>

801065c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $197
801065c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065ca:	e9 60 f3 ff ff       	jmp    8010592f <alltraps>

801065cf <vector198>:
.globl vector198
vector198:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $198
801065d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065d6:	e9 54 f3 ff ff       	jmp    8010592f <alltraps>

801065db <vector199>:
.globl vector199
vector199:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $199
801065dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065e2:	e9 48 f3 ff ff       	jmp    8010592f <alltraps>

801065e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $200
801065e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801065ee:	e9 3c f3 ff ff       	jmp    8010592f <alltraps>

801065f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $201
801065f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065fa:	e9 30 f3 ff ff       	jmp    8010592f <alltraps>

801065ff <vector202>:
.globl vector202
vector202:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $202
80106601:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106606:	e9 24 f3 ff ff       	jmp    8010592f <alltraps>

8010660b <vector203>:
.globl vector203
vector203:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $203
8010660d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106612:	e9 18 f3 ff ff       	jmp    8010592f <alltraps>

80106617 <vector204>:
.globl vector204
vector204:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $204
80106619:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010661e:	e9 0c f3 ff ff       	jmp    8010592f <alltraps>

80106623 <vector205>:
.globl vector205
vector205:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $205
80106625:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010662a:	e9 00 f3 ff ff       	jmp    8010592f <alltraps>

8010662f <vector206>:
.globl vector206
vector206:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $206
80106631:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106636:	e9 f4 f2 ff ff       	jmp    8010592f <alltraps>

8010663b <vector207>:
.globl vector207
vector207:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $207
8010663d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106642:	e9 e8 f2 ff ff       	jmp    8010592f <alltraps>

80106647 <vector208>:
.globl vector208
vector208:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $208
80106649:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010664e:	e9 dc f2 ff ff       	jmp    8010592f <alltraps>

80106653 <vector209>:
.globl vector209
vector209:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $209
80106655:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010665a:	e9 d0 f2 ff ff       	jmp    8010592f <alltraps>

8010665f <vector210>:
.globl vector210
vector210:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $210
80106661:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106666:	e9 c4 f2 ff ff       	jmp    8010592f <alltraps>

8010666b <vector211>:
.globl vector211
vector211:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $211
8010666d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106672:	e9 b8 f2 ff ff       	jmp    8010592f <alltraps>

80106677 <vector212>:
.globl vector212
vector212:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $212
80106679:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010667e:	e9 ac f2 ff ff       	jmp    8010592f <alltraps>

80106683 <vector213>:
.globl vector213
vector213:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $213
80106685:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010668a:	e9 a0 f2 ff ff       	jmp    8010592f <alltraps>

8010668f <vector214>:
.globl vector214
vector214:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $214
80106691:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106696:	e9 94 f2 ff ff       	jmp    8010592f <alltraps>

8010669b <vector215>:
.globl vector215
vector215:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $215
8010669d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801066a2:	e9 88 f2 ff ff       	jmp    8010592f <alltraps>

801066a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $216
801066a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801066ae:	e9 7c f2 ff ff       	jmp    8010592f <alltraps>

801066b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $217
801066b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066ba:	e9 70 f2 ff ff       	jmp    8010592f <alltraps>

801066bf <vector218>:
.globl vector218
vector218:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $218
801066c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066c6:	e9 64 f2 ff ff       	jmp    8010592f <alltraps>

801066cb <vector219>:
.globl vector219
vector219:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $219
801066cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066d2:	e9 58 f2 ff ff       	jmp    8010592f <alltraps>

801066d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $220
801066d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066de:	e9 4c f2 ff ff       	jmp    8010592f <alltraps>

801066e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $221
801066e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066ea:	e9 40 f2 ff ff       	jmp    8010592f <alltraps>

801066ef <vector222>:
.globl vector222
vector222:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $222
801066f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066f6:	e9 34 f2 ff ff       	jmp    8010592f <alltraps>

801066fb <vector223>:
.globl vector223
vector223:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $223
801066fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106702:	e9 28 f2 ff ff       	jmp    8010592f <alltraps>

80106707 <vector224>:
.globl vector224
vector224:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $224
80106709:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010670e:	e9 1c f2 ff ff       	jmp    8010592f <alltraps>

80106713 <vector225>:
.globl vector225
vector225:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $225
80106715:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010671a:	e9 10 f2 ff ff       	jmp    8010592f <alltraps>

8010671f <vector226>:
.globl vector226
vector226:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $226
80106721:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106726:	e9 04 f2 ff ff       	jmp    8010592f <alltraps>

8010672b <vector227>:
.globl vector227
vector227:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $227
8010672d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106732:	e9 f8 f1 ff ff       	jmp    8010592f <alltraps>

80106737 <vector228>:
.globl vector228
vector228:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $228
80106739:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010673e:	e9 ec f1 ff ff       	jmp    8010592f <alltraps>

80106743 <vector229>:
.globl vector229
vector229:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $229
80106745:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010674a:	e9 e0 f1 ff ff       	jmp    8010592f <alltraps>

8010674f <vector230>:
.globl vector230
vector230:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $230
80106751:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106756:	e9 d4 f1 ff ff       	jmp    8010592f <alltraps>

8010675b <vector231>:
.globl vector231
vector231:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $231
8010675d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106762:	e9 c8 f1 ff ff       	jmp    8010592f <alltraps>

80106767 <vector232>:
.globl vector232
vector232:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $232
80106769:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010676e:	e9 bc f1 ff ff       	jmp    8010592f <alltraps>

80106773 <vector233>:
.globl vector233
vector233:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $233
80106775:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010677a:	e9 b0 f1 ff ff       	jmp    8010592f <alltraps>

8010677f <vector234>:
.globl vector234
vector234:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $234
80106781:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106786:	e9 a4 f1 ff ff       	jmp    8010592f <alltraps>

8010678b <vector235>:
.globl vector235
vector235:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $235
8010678d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106792:	e9 98 f1 ff ff       	jmp    8010592f <alltraps>

80106797 <vector236>:
.globl vector236
vector236:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $236
80106799:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010679e:	e9 8c f1 ff ff       	jmp    8010592f <alltraps>

801067a3 <vector237>:
.globl vector237
vector237:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $237
801067a5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801067aa:	e9 80 f1 ff ff       	jmp    8010592f <alltraps>

801067af <vector238>:
.globl vector238
vector238:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $238
801067b1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067b6:	e9 74 f1 ff ff       	jmp    8010592f <alltraps>

801067bb <vector239>:
.globl vector239
vector239:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $239
801067bd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067c2:	e9 68 f1 ff ff       	jmp    8010592f <alltraps>

801067c7 <vector240>:
.globl vector240
vector240:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $240
801067c9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067ce:	e9 5c f1 ff ff       	jmp    8010592f <alltraps>

801067d3 <vector241>:
.globl vector241
vector241:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $241
801067d5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067da:	e9 50 f1 ff ff       	jmp    8010592f <alltraps>

801067df <vector242>:
.globl vector242
vector242:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $242
801067e1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067e6:	e9 44 f1 ff ff       	jmp    8010592f <alltraps>

801067eb <vector243>:
.globl vector243
vector243:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $243
801067ed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067f2:	e9 38 f1 ff ff       	jmp    8010592f <alltraps>

801067f7 <vector244>:
.globl vector244
vector244:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $244
801067f9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067fe:	e9 2c f1 ff ff       	jmp    8010592f <alltraps>

80106803 <vector245>:
.globl vector245
vector245:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $245
80106805:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010680a:	e9 20 f1 ff ff       	jmp    8010592f <alltraps>

8010680f <vector246>:
.globl vector246
vector246:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $246
80106811:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106816:	e9 14 f1 ff ff       	jmp    8010592f <alltraps>

8010681b <vector247>:
.globl vector247
vector247:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $247
8010681d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106822:	e9 08 f1 ff ff       	jmp    8010592f <alltraps>

80106827 <vector248>:
.globl vector248
vector248:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $248
80106829:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010682e:	e9 fc f0 ff ff       	jmp    8010592f <alltraps>

80106833 <vector249>:
.globl vector249
vector249:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $249
80106835:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010683a:	e9 f0 f0 ff ff       	jmp    8010592f <alltraps>

8010683f <vector250>:
.globl vector250
vector250:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $250
80106841:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106846:	e9 e4 f0 ff ff       	jmp    8010592f <alltraps>

8010684b <vector251>:
.globl vector251
vector251:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $251
8010684d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106852:	e9 d8 f0 ff ff       	jmp    8010592f <alltraps>

80106857 <vector252>:
.globl vector252
vector252:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $252
80106859:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010685e:	e9 cc f0 ff ff       	jmp    8010592f <alltraps>

80106863 <vector253>:
.globl vector253
vector253:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $253
80106865:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010686a:	e9 c0 f0 ff ff       	jmp    8010592f <alltraps>

8010686f <vector254>:
.globl vector254
vector254:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $254
80106871:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106876:	e9 b4 f0 ff ff       	jmp    8010592f <alltraps>

8010687b <vector255>:
.globl vector255
vector255:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $255
8010687d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106882:	e9 a8 f0 ff ff       	jmp    8010592f <alltraps>
80106887:	66 90                	xchg   %ax,%ax
80106889:	66 90                	xchg   %ax,%ax
8010688b:	66 90                	xchg   %ax,%ax
8010688d:	66 90                	xchg   %ax,%ax
8010688f:	90                   	nop

80106890 <walkpgdir>:
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	53                   	push   %ebx
80106896:	89 d3                	mov    %edx,%ebx
80106898:	89 d7                	mov    %edx,%edi
8010689a:	c1 eb 16             	shr    $0x16,%ebx
8010689d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
801068a0:	83 ec 0c             	sub    $0xc,%esp
801068a3:	8b 06                	mov    (%esi),%eax
801068a5:	a8 01                	test   $0x1,%al
801068a7:	74 27                	je     801068d0 <walkpgdir+0x40>
801068a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068ae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801068b4:	c1 ef 0a             	shr    $0xa,%edi
801068b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068ba:	89 fa                	mov    %edi,%edx
801068bc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801068c2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
801068c5:	5b                   	pop    %ebx
801068c6:	5e                   	pop    %esi
801068c7:	5f                   	pop    %edi
801068c8:	5d                   	pop    %ebp
801068c9:	c3                   	ret    
801068ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801068d0:	85 c9                	test   %ecx,%ecx
801068d2:	74 2c                	je     80106900 <walkpgdir+0x70>
801068d4:	e8 e7 bb ff ff       	call   801024c0 <kalloc>
801068d9:	85 c0                	test   %eax,%eax
801068db:	89 c3                	mov    %eax,%ebx
801068dd:	74 21                	je     80106900 <walkpgdir+0x70>
801068df:	83 ec 04             	sub    $0x4,%esp
801068e2:	68 00 10 00 00       	push   $0x1000
801068e7:	6a 00                	push   $0x0
801068e9:	50                   	push   %eax
801068ea:	e8 01 de ff ff       	call   801046f0 <memset>
801068ef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068f5:	83 c4 10             	add    $0x10,%esp
801068f8:	83 c8 07             	or     $0x7,%eax
801068fb:	89 06                	mov    %eax,(%esi)
801068fd:	eb b5                	jmp    801068b4 <walkpgdir+0x24>
801068ff:	90                   	nop
80106900:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106903:	31 c0                	xor    %eax,%eax
80106905:	5b                   	pop    %ebx
80106906:	5e                   	pop    %esi
80106907:	5f                   	pop    %edi
80106908:	5d                   	pop    %ebp
80106909:	c3                   	ret    
8010690a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106910 <mappages>:
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	89 d3                	mov    %edx,%ebx
80106918:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010691e:	83 ec 1c             	sub    $0x1c,%esp
80106921:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106924:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106928:	8b 7d 08             	mov    0x8(%ebp),%edi
8010692b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106930:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106933:	8b 45 0c             	mov    0xc(%ebp),%eax
80106936:	29 df                	sub    %ebx,%edi
80106938:	83 c8 01             	or     $0x1,%eax
8010693b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010693e:	eb 15                	jmp    80106955 <mappages+0x45>
80106940:	f6 00 01             	testb  $0x1,(%eax)
80106943:	75 45                	jne    8010698a <mappages+0x7a>
80106945:	0b 75 dc             	or     -0x24(%ebp),%esi
80106948:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
8010694b:	89 30                	mov    %esi,(%eax)
8010694d:	74 31                	je     80106980 <mappages+0x70>
8010694f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106958:	b9 01 00 00 00       	mov    $0x1,%ecx
8010695d:	89 da                	mov    %ebx,%edx
8010695f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106962:	e8 29 ff ff ff       	call   80106890 <walkpgdir>
80106967:	85 c0                	test   %eax,%eax
80106969:	75 d5                	jne    80106940 <mappages+0x30>
8010696b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010696e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106973:	5b                   	pop    %ebx
80106974:	5e                   	pop    %esi
80106975:	5f                   	pop    %edi
80106976:	5d                   	pop    %ebp
80106977:	c3                   	ret    
80106978:	90                   	nop
80106979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106980:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106983:	31 c0                	xor    %eax,%eax
80106985:	5b                   	pop    %ebx
80106986:	5e                   	pop    %esi
80106987:	5f                   	pop    %edi
80106988:	5d                   	pop    %ebp
80106989:	c3                   	ret    
8010698a:	83 ec 0c             	sub    $0xc,%esp
8010698d:	68 d4 7b 10 80       	push   $0x80107bd4
80106992:	e8 f9 99 ff ff       	call   80100390 <panic>
80106997:	89 f6                	mov    %esi,%esi
80106999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069a0 <deallocuvm.part.0>:
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	57                   	push   %edi
801069a4:	56                   	push   %esi
801069a5:	53                   	push   %ebx
801069a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801069ac:	89 c7                	mov    %eax,%edi
801069ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801069b4:	83 ec 1c             	sub    $0x1c,%esp
801069b7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801069ba:	39 d3                	cmp    %edx,%ebx
801069bc:	73 66                	jae    80106a24 <deallocuvm.part.0+0x84>
801069be:	89 d6                	mov    %edx,%esi
801069c0:	eb 3d                	jmp    801069ff <deallocuvm.part.0+0x5f>
801069c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069c8:	8b 10                	mov    (%eax),%edx
801069ca:	f6 c2 01             	test   $0x1,%dl
801069cd:	74 26                	je     801069f5 <deallocuvm.part.0+0x55>
801069cf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801069d5:	74 58                	je     80106a2f <deallocuvm.part.0+0x8f>
801069d7:	83 ec 0c             	sub    $0xc,%esp
801069da:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801069e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069e3:	52                   	push   %edx
801069e4:	e8 27 b9 ff ff       	call   80102310 <kfree>
801069e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801069ec:	83 c4 10             	add    $0x10,%esp
801069ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801069f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069fb:	39 f3                	cmp    %esi,%ebx
801069fd:	73 25                	jae    80106a24 <deallocuvm.part.0+0x84>
801069ff:	31 c9                	xor    %ecx,%ecx
80106a01:	89 da                	mov    %ebx,%edx
80106a03:	89 f8                	mov    %edi,%eax
80106a05:	e8 86 fe ff ff       	call   80106890 <walkpgdir>
80106a0a:	85 c0                	test   %eax,%eax
80106a0c:	75 ba                	jne    801069c8 <deallocuvm.part.0+0x28>
80106a0e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106a14:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
80106a1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a20:	39 f3                	cmp    %esi,%ebx
80106a22:	72 db                	jb     801069ff <deallocuvm.part.0+0x5f>
80106a24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a2a:	5b                   	pop    %ebx
80106a2b:	5e                   	pop    %esi
80106a2c:	5f                   	pop    %edi
80106a2d:	5d                   	pop    %ebp
80106a2e:	c3                   	ret    
80106a2f:	83 ec 0c             	sub    $0xc,%esp
80106a32:	68 26 74 10 80       	push   $0x80107426
80106a37:	e8 54 99 ff ff       	call   80100390 <panic>
80106a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a40 <seginit>:
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	83 ec 18             	sub    $0x18,%esp
80106a46:	e8 75 cd ff ff       	call   801037c0 <cpuid>
80106a4b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a51:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106a56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106a5a:	c7 80 98 29 11 80 ff 	movl   $0xffff,-0x7feed668(%eax)
80106a61:	ff 00 00 
80106a64:	c7 80 9c 29 11 80 00 	movl   $0xcf9a00,-0x7feed664(%eax)
80106a6b:	9a cf 00 
80106a6e:	c7 80 a0 29 11 80 ff 	movl   $0xffff,-0x7feed660(%eax)
80106a75:	ff 00 00 
80106a78:	c7 80 a4 29 11 80 00 	movl   $0xcf9200,-0x7feed65c(%eax)
80106a7f:	92 cf 00 
80106a82:	c7 80 a8 29 11 80 ff 	movl   $0xffff,-0x7feed658(%eax)
80106a89:	ff 00 00 
80106a8c:	c7 80 ac 29 11 80 00 	movl   $0xcffa00,-0x7feed654(%eax)
80106a93:	fa cf 00 
80106a96:	c7 80 b0 29 11 80 ff 	movl   $0xffff,-0x7feed650(%eax)
80106a9d:	ff 00 00 
80106aa0:	c7 80 b4 29 11 80 00 	movl   $0xcff200,-0x7feed64c(%eax)
80106aa7:	f2 cf 00 
80106aaa:	05 90 29 11 80       	add    $0x80112990,%eax
80106aaf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
80106ab3:	c1 e8 10             	shr    $0x10,%eax
80106ab6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
80106aba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106abd:	0f 01 10             	lgdtl  (%eax)
80106ac0:	c9                   	leave  
80106ac1:	c3                   	ret    
80106ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ad0 <switchkvm>:
80106ad0:	a1 c4 56 11 80       	mov    0x801156c4,%eax
80106ad5:	55                   	push   %ebp
80106ad6:	89 e5                	mov    %esp,%ebp
80106ad8:	05 00 00 00 80       	add    $0x80000000,%eax
80106add:	0f 22 d8             	mov    %eax,%cr3
80106ae0:	5d                   	pop    %ebp
80106ae1:	c3                   	ret    
80106ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106af0 <switchuvm>:
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	57                   	push   %edi
80106af4:	56                   	push   %esi
80106af5:	53                   	push   %ebx
80106af6:	83 ec 1c             	sub    $0x1c,%esp
80106af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106afc:	85 db                	test   %ebx,%ebx
80106afe:	0f 84 cb 00 00 00    	je     80106bcf <switchuvm+0xdf>
80106b04:	8b 43 08             	mov    0x8(%ebx),%eax
80106b07:	85 c0                	test   %eax,%eax
80106b09:	0f 84 da 00 00 00    	je     80106be9 <switchuvm+0xf9>
80106b0f:	8b 43 04             	mov    0x4(%ebx),%eax
80106b12:	85 c0                	test   %eax,%eax
80106b14:	0f 84 c2 00 00 00    	je     80106bdc <switchuvm+0xec>
80106b1a:	e8 e1 d9 ff ff       	call   80104500 <pushcli>
80106b1f:	e8 1c cc ff ff       	call   80103740 <mycpu>
80106b24:	89 c6                	mov    %eax,%esi
80106b26:	e8 15 cc ff ff       	call   80103740 <mycpu>
80106b2b:	89 c7                	mov    %eax,%edi
80106b2d:	e8 0e cc ff ff       	call   80103740 <mycpu>
80106b32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b35:	83 c7 08             	add    $0x8,%edi
80106b38:	e8 03 cc ff ff       	call   80103740 <mycpu>
80106b3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b40:	83 c0 08             	add    $0x8,%eax
80106b43:	ba 67 00 00 00       	mov    $0x67,%edx
80106b48:	c1 e8 18             	shr    $0x18,%eax
80106b4b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106b52:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106b59:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
80106b5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80106b64:	83 c1 08             	add    $0x8,%ecx
80106b67:	c1 e9 10             	shr    $0x10,%ecx
80106b6a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106b70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b75:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
80106b7c:	be 10 00 00 00       	mov    $0x10,%esi
80106b81:	e8 ba cb ff ff       	call   80103740 <mycpu>
80106b86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
80106b8d:	e8 ae cb ff ff       	call   80103740 <mycpu>
80106b92:	66 89 70 10          	mov    %si,0x10(%eax)
80106b96:	8b 73 08             	mov    0x8(%ebx),%esi
80106b99:	e8 a2 cb ff ff       	call   80103740 <mycpu>
80106b9e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ba4:	89 70 0c             	mov    %esi,0xc(%eax)
80106ba7:	e8 94 cb ff ff       	call   80103740 <mycpu>
80106bac:	66 89 78 6e          	mov    %di,0x6e(%eax)
80106bb0:	b8 28 00 00 00       	mov    $0x28,%eax
80106bb5:	0f 00 d8             	ltr    %ax
80106bb8:	8b 43 04             	mov    0x4(%ebx),%eax
80106bbb:	05 00 00 00 80       	add    $0x80000000,%eax
80106bc0:	0f 22 d8             	mov    %eax,%cr3
80106bc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bc6:	5b                   	pop    %ebx
80106bc7:	5e                   	pop    %esi
80106bc8:	5f                   	pop    %edi
80106bc9:	5d                   	pop    %ebp
80106bca:	e9 71 d9 ff ff       	jmp    80104540 <popcli>
80106bcf:	83 ec 0c             	sub    $0xc,%esp
80106bd2:	68 da 7b 10 80       	push   $0x80107bda
80106bd7:	e8 b4 97 ff ff       	call   80100390 <panic>
80106bdc:	83 ec 0c             	sub    $0xc,%esp
80106bdf:	68 05 7c 10 80       	push   $0x80107c05
80106be4:	e8 a7 97 ff ff       	call   80100390 <panic>
80106be9:	83 ec 0c             	sub    $0xc,%esp
80106bec:	68 f0 7b 10 80       	push   $0x80107bf0
80106bf1:	e8 9a 97 ff ff       	call   80100390 <panic>
80106bf6:	8d 76 00             	lea    0x0(%esi),%esi
80106bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c00 <inituvm>:
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
80106c06:	83 ec 1c             	sub    $0x1c,%esp
80106c09:	8b 75 10             	mov    0x10(%ebp),%esi
80106c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c0f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106c12:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c1b:	77 49                	ja     80106c66 <inituvm+0x66>
80106c1d:	e8 9e b8 ff ff       	call   801024c0 <kalloc>
80106c22:	83 ec 04             	sub    $0x4,%esp
80106c25:	89 c3                	mov    %eax,%ebx
80106c27:	68 00 10 00 00       	push   $0x1000
80106c2c:	6a 00                	push   $0x0
80106c2e:	50                   	push   %eax
80106c2f:	e8 bc da ff ff       	call   801046f0 <memset>
80106c34:	58                   	pop    %eax
80106c35:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c3b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c40:	5a                   	pop    %edx
80106c41:	6a 06                	push   $0x6
80106c43:	50                   	push   %eax
80106c44:	31 d2                	xor    %edx,%edx
80106c46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c49:	e8 c2 fc ff ff       	call   80106910 <mappages>
80106c4e:	89 75 10             	mov    %esi,0x10(%ebp)
80106c51:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c54:	83 c4 10             	add    $0x10,%esp
80106c57:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c5d:	5b                   	pop    %ebx
80106c5e:	5e                   	pop    %esi
80106c5f:	5f                   	pop    %edi
80106c60:	5d                   	pop    %ebp
80106c61:	e9 3a db ff ff       	jmp    801047a0 <memmove>
80106c66:	83 ec 0c             	sub    $0xc,%esp
80106c69:	68 19 7c 10 80       	push   $0x80107c19
80106c6e:	e8 1d 97 ff ff       	call   80100390 <panic>
80106c73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c80 <loaduvm>:
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 0c             	sub    $0xc,%esp
80106c89:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106c90:	0f 85 91 00 00 00    	jne    80106d27 <loaduvm+0xa7>
80106c96:	8b 75 18             	mov    0x18(%ebp),%esi
80106c99:	31 db                	xor    %ebx,%ebx
80106c9b:	85 f6                	test   %esi,%esi
80106c9d:	75 1a                	jne    80106cb9 <loaduvm+0x39>
80106c9f:	eb 6f                	jmp    80106d10 <loaduvm+0x90>
80106ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ca8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106cb4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106cb7:	76 57                	jbe    80106d10 <loaduvm+0x90>
80106cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80106cbf:	31 c9                	xor    %ecx,%ecx
80106cc1:	01 da                	add    %ebx,%edx
80106cc3:	e8 c8 fb ff ff       	call   80106890 <walkpgdir>
80106cc8:	85 c0                	test   %eax,%eax
80106cca:	74 4e                	je     80106d1a <loaduvm+0x9a>
80106ccc:	8b 00                	mov    (%eax),%eax
80106cce:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106cd1:	bf 00 10 00 00       	mov    $0x1000,%edi
80106cd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cdb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ce1:	0f 46 fe             	cmovbe %esi,%edi
80106ce4:	01 d9                	add    %ebx,%ecx
80106ce6:	05 00 00 00 80       	add    $0x80000000,%eax
80106ceb:	57                   	push   %edi
80106cec:	51                   	push   %ecx
80106ced:	50                   	push   %eax
80106cee:	ff 75 10             	pushl  0x10(%ebp)
80106cf1:	e8 6a ac ff ff       	call   80101960 <readi>
80106cf6:	83 c4 10             	add    $0x10,%esp
80106cf9:	39 f8                	cmp    %edi,%eax
80106cfb:	74 ab                	je     80106ca8 <loaduvm+0x28>
80106cfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d05:	5b                   	pop    %ebx
80106d06:	5e                   	pop    %esi
80106d07:	5f                   	pop    %edi
80106d08:	5d                   	pop    %ebp
80106d09:	c3                   	ret    
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d13:	31 c0                	xor    %eax,%eax
80106d15:	5b                   	pop    %ebx
80106d16:	5e                   	pop    %esi
80106d17:	5f                   	pop    %edi
80106d18:	5d                   	pop    %ebp
80106d19:	c3                   	ret    
80106d1a:	83 ec 0c             	sub    $0xc,%esp
80106d1d:	68 33 7c 10 80       	push   $0x80107c33
80106d22:	e8 69 96 ff ff       	call   80100390 <panic>
80106d27:	83 ec 0c             	sub    $0xc,%esp
80106d2a:	68 d4 7c 10 80       	push   $0x80107cd4
80106d2f:	e8 5c 96 ff ff       	call   80100390 <panic>
80106d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d40 <allocuvm>:
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	57                   	push   %edi
80106d44:	56                   	push   %esi
80106d45:	53                   	push   %ebx
80106d46:	83 ec 1c             	sub    $0x1c,%esp
80106d49:	8b 7d 10             	mov    0x10(%ebp),%edi
80106d4c:	85 ff                	test   %edi,%edi
80106d4e:	0f 88 8e 00 00 00    	js     80106de2 <allocuvm+0xa2>
80106d54:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d57:	0f 82 93 00 00 00    	jb     80106df0 <allocuvm+0xb0>
80106d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d60:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d66:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106d6c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106d6f:	0f 86 7e 00 00 00    	jbe    80106df3 <allocuvm+0xb3>
80106d75:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106d78:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d7b:	eb 42                	jmp    80106dbf <allocuvm+0x7f>
80106d7d:	8d 76 00             	lea    0x0(%esi),%esi
80106d80:	83 ec 04             	sub    $0x4,%esp
80106d83:	68 00 10 00 00       	push   $0x1000
80106d88:	6a 00                	push   $0x0
80106d8a:	50                   	push   %eax
80106d8b:	e8 60 d9 ff ff       	call   801046f0 <memset>
80106d90:	58                   	pop    %eax
80106d91:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d97:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d9c:	5a                   	pop    %edx
80106d9d:	6a 06                	push   $0x6
80106d9f:	50                   	push   %eax
80106da0:	89 da                	mov    %ebx,%edx
80106da2:	89 f8                	mov    %edi,%eax
80106da4:	e8 67 fb ff ff       	call   80106910 <mappages>
80106da9:	83 c4 10             	add    $0x10,%esp
80106dac:	85 c0                	test   %eax,%eax
80106dae:	78 50                	js     80106e00 <allocuvm+0xc0>
80106db0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106db6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106db9:	0f 86 81 00 00 00    	jbe    80106e40 <allocuvm+0x100>
80106dbf:	e8 fc b6 ff ff       	call   801024c0 <kalloc>
80106dc4:	85 c0                	test   %eax,%eax
80106dc6:	89 c6                	mov    %eax,%esi
80106dc8:	75 b6                	jne    80106d80 <allocuvm+0x40>
80106dca:	83 ec 0c             	sub    $0xc,%esp
80106dcd:	68 51 7c 10 80       	push   $0x80107c51
80106dd2:	e8 89 98 ff ff       	call   80100660 <cprintf>
80106dd7:	83 c4 10             	add    $0x10,%esp
80106dda:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ddd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106de0:	77 6e                	ja     80106e50 <allocuvm+0x110>
80106de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de5:	31 ff                	xor    %edi,%edi
80106de7:	89 f8                	mov    %edi,%eax
80106de9:	5b                   	pop    %ebx
80106dea:	5e                   	pop    %esi
80106deb:	5f                   	pop    %edi
80106dec:	5d                   	pop    %ebp
80106ded:	c3                   	ret    
80106dee:	66 90                	xchg   %ax,%ax
80106df0:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106df6:	89 f8                	mov    %edi,%eax
80106df8:	5b                   	pop    %ebx
80106df9:	5e                   	pop    %esi
80106dfa:	5f                   	pop    %edi
80106dfb:	5d                   	pop    %ebp
80106dfc:	c3                   	ret    
80106dfd:	8d 76 00             	lea    0x0(%esi),%esi
80106e00:	83 ec 0c             	sub    $0xc,%esp
80106e03:	68 69 7c 10 80       	push   $0x80107c69
80106e08:	e8 53 98 ff ff       	call   80100660 <cprintf>
80106e0d:	83 c4 10             	add    $0x10,%esp
80106e10:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e13:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e16:	76 0d                	jbe    80106e25 <allocuvm+0xe5>
80106e18:	89 c1                	mov    %eax,%ecx
80106e1a:	8b 55 10             	mov    0x10(%ebp),%edx
80106e1d:	8b 45 08             	mov    0x8(%ebp),%eax
80106e20:	e8 7b fb ff ff       	call   801069a0 <deallocuvm.part.0>
80106e25:	83 ec 0c             	sub    $0xc,%esp
80106e28:	31 ff                	xor    %edi,%edi
80106e2a:	56                   	push   %esi
80106e2b:	e8 e0 b4 ff ff       	call   80102310 <kfree>
80106e30:	83 c4 10             	add    $0x10,%esp
80106e33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e36:	89 f8                	mov    %edi,%eax
80106e38:	5b                   	pop    %ebx
80106e39:	5e                   	pop    %esi
80106e3a:	5f                   	pop    %edi
80106e3b:	5d                   	pop    %ebp
80106e3c:	c3                   	ret    
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi
80106e40:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e46:	5b                   	pop    %ebx
80106e47:	89 f8                	mov    %edi,%eax
80106e49:	5e                   	pop    %esi
80106e4a:	5f                   	pop    %edi
80106e4b:	5d                   	pop    %ebp
80106e4c:	c3                   	ret    
80106e4d:	8d 76 00             	lea    0x0(%esi),%esi
80106e50:	89 c1                	mov    %eax,%ecx
80106e52:	8b 55 10             	mov    0x10(%ebp),%edx
80106e55:	8b 45 08             	mov    0x8(%ebp),%eax
80106e58:	31 ff                	xor    %edi,%edi
80106e5a:	e8 41 fb ff ff       	call   801069a0 <deallocuvm.part.0>
80106e5f:	eb 92                	jmp    80106df3 <allocuvm+0xb3>
80106e61:	eb 0d                	jmp    80106e70 <deallocuvm>
80106e63:	90                   	nop
80106e64:	90                   	nop
80106e65:	90                   	nop
80106e66:	90                   	nop
80106e67:	90                   	nop
80106e68:	90                   	nop
80106e69:	90                   	nop
80106e6a:	90                   	nop
80106e6b:	90                   	nop
80106e6c:	90                   	nop
80106e6d:	90                   	nop
80106e6e:	90                   	nop
80106e6f:	90                   	nop

80106e70 <deallocuvm>:
80106e70:	55                   	push   %ebp
80106e71:	89 e5                	mov    %esp,%ebp
80106e73:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e79:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7c:	39 d1                	cmp    %edx,%ecx
80106e7e:	73 10                	jae    80106e90 <deallocuvm+0x20>
80106e80:	5d                   	pop    %ebp
80106e81:	e9 1a fb ff ff       	jmp    801069a0 <deallocuvm.part.0>
80106e86:	8d 76 00             	lea    0x0(%esi),%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e90:	89 d0                	mov    %edx,%eax
80106e92:	5d                   	pop    %ebp
80106e93:	c3                   	ret    
80106e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ea0 <freevm>:
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 0c             	sub    $0xc,%esp
80106ea9:	8b 75 08             	mov    0x8(%ebp),%esi
80106eac:	85 f6                	test   %esi,%esi
80106eae:	74 59                	je     80106f09 <freevm+0x69>
80106eb0:	31 c9                	xor    %ecx,%ecx
80106eb2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106eb7:	89 f0                	mov    %esi,%eax
80106eb9:	e8 e2 fa ff ff       	call   801069a0 <deallocuvm.part.0>
80106ebe:	89 f3                	mov    %esi,%ebx
80106ec0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ec6:	eb 0f                	jmp    80106ed7 <freevm+0x37>
80106ec8:	90                   	nop
80106ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ed0:	83 c3 04             	add    $0x4,%ebx
80106ed3:	39 fb                	cmp    %edi,%ebx
80106ed5:	74 23                	je     80106efa <freevm+0x5a>
80106ed7:	8b 03                	mov    (%ebx),%eax
80106ed9:	a8 01                	test   $0x1,%al
80106edb:	74 f3                	je     80106ed0 <freevm+0x30>
80106edd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ee2:	83 ec 0c             	sub    $0xc,%esp
80106ee5:	83 c3 04             	add    $0x4,%ebx
80106ee8:	05 00 00 00 80       	add    $0x80000000,%eax
80106eed:	50                   	push   %eax
80106eee:	e8 1d b4 ff ff       	call   80102310 <kfree>
80106ef3:	83 c4 10             	add    $0x10,%esp
80106ef6:	39 fb                	cmp    %edi,%ebx
80106ef8:	75 dd                	jne    80106ed7 <freevm+0x37>
80106efa:	89 75 08             	mov    %esi,0x8(%ebp)
80106efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f00:	5b                   	pop    %ebx
80106f01:	5e                   	pop    %esi
80106f02:	5f                   	pop    %edi
80106f03:	5d                   	pop    %ebp
80106f04:	e9 07 b4 ff ff       	jmp    80102310 <kfree>
80106f09:	83 ec 0c             	sub    $0xc,%esp
80106f0c:	68 85 7c 10 80       	push   $0x80107c85
80106f11:	e8 7a 94 ff ff       	call   80100390 <panic>
80106f16:	8d 76 00             	lea    0x0(%esi),%esi
80106f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f20 <setupkvm>:
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	56                   	push   %esi
80106f24:	53                   	push   %ebx
80106f25:	e8 96 b5 ff ff       	call   801024c0 <kalloc>
80106f2a:	85 c0                	test   %eax,%eax
80106f2c:	89 c6                	mov    %eax,%esi
80106f2e:	74 42                	je     80106f72 <setupkvm+0x52>
80106f30:	83 ec 04             	sub    $0x4,%esp
80106f33:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106f38:	68 00 10 00 00       	push   $0x1000
80106f3d:	6a 00                	push   $0x0
80106f3f:	50                   	push   %eax
80106f40:	e8 ab d7 ff ff       	call   801046f0 <memset>
80106f45:	83 c4 10             	add    $0x10,%esp
80106f48:	8b 43 04             	mov    0x4(%ebx),%eax
80106f4b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f4e:	83 ec 08             	sub    $0x8,%esp
80106f51:	8b 13                	mov    (%ebx),%edx
80106f53:	ff 73 0c             	pushl  0xc(%ebx)
80106f56:	50                   	push   %eax
80106f57:	29 c1                	sub    %eax,%ecx
80106f59:	89 f0                	mov    %esi,%eax
80106f5b:	e8 b0 f9 ff ff       	call   80106910 <mappages>
80106f60:	83 c4 10             	add    $0x10,%esp
80106f63:	85 c0                	test   %eax,%eax
80106f65:	78 19                	js     80106f80 <setupkvm+0x60>
80106f67:	83 c3 10             	add    $0x10,%ebx
80106f6a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f70:	75 d6                	jne    80106f48 <setupkvm+0x28>
80106f72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f75:	89 f0                	mov    %esi,%eax
80106f77:	5b                   	pop    %ebx
80106f78:	5e                   	pop    %esi
80106f79:	5d                   	pop    %ebp
80106f7a:	c3                   	ret    
80106f7b:	90                   	nop
80106f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f80:	83 ec 0c             	sub    $0xc,%esp
80106f83:	56                   	push   %esi
80106f84:	31 f6                	xor    %esi,%esi
80106f86:	e8 15 ff ff ff       	call   80106ea0 <freevm>
80106f8b:	83 c4 10             	add    $0x10,%esp
80106f8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f91:	89 f0                	mov    %esi,%eax
80106f93:	5b                   	pop    %ebx
80106f94:	5e                   	pop    %esi
80106f95:	5d                   	pop    %ebp
80106f96:	c3                   	ret    
80106f97:	89 f6                	mov    %esi,%esi
80106f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fa0 <kvmalloc>:
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	83 ec 08             	sub    $0x8,%esp
80106fa6:	e8 75 ff ff ff       	call   80106f20 <setupkvm>
80106fab:	a3 c4 56 11 80       	mov    %eax,0x801156c4
80106fb0:	05 00 00 00 80       	add    $0x80000000,%eax
80106fb5:	0f 22 d8             	mov    %eax,%cr3
80106fb8:	c9                   	leave  
80106fb9:	c3                   	ret    
80106fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fc0 <clearpteu>:
80106fc0:	55                   	push   %ebp
80106fc1:	31 c9                	xor    %ecx,%ecx
80106fc3:	89 e5                	mov    %esp,%ebp
80106fc5:	83 ec 08             	sub    $0x8,%esp
80106fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fce:	e8 bd f8 ff ff       	call   80106890 <walkpgdir>
80106fd3:	85 c0                	test   %eax,%eax
80106fd5:	74 05                	je     80106fdc <clearpteu+0x1c>
80106fd7:	83 20 fb             	andl   $0xfffffffb,(%eax)
80106fda:	c9                   	leave  
80106fdb:	c3                   	ret    
80106fdc:	83 ec 0c             	sub    $0xc,%esp
80106fdf:	68 96 7c 10 80       	push   $0x80107c96
80106fe4:	e8 a7 93 ff ff       	call   80100390 <panic>
80106fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <copyuvm>:
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
80106ff9:	e8 22 ff ff ff       	call   80106f20 <setupkvm>
80106ffe:	85 c0                	test   %eax,%eax
80107000:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107003:	0f 84 9f 00 00 00    	je     801070a8 <copyuvm+0xb8>
80107009:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010700c:	85 c9                	test   %ecx,%ecx
8010700e:	0f 84 94 00 00 00    	je     801070a8 <copyuvm+0xb8>
80107014:	31 ff                	xor    %edi,%edi
80107016:	eb 4a                	jmp    80107062 <copyuvm+0x72>
80107018:	90                   	nop
80107019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107020:	83 ec 04             	sub    $0x4,%esp
80107023:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107029:	68 00 10 00 00       	push   $0x1000
8010702e:	53                   	push   %ebx
8010702f:	50                   	push   %eax
80107030:	e8 6b d7 ff ff       	call   801047a0 <memmove>
80107035:	58                   	pop    %eax
80107036:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010703c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107041:	5a                   	pop    %edx
80107042:	ff 75 e4             	pushl  -0x1c(%ebp)
80107045:	50                   	push   %eax
80107046:	89 fa                	mov    %edi,%edx
80107048:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010704b:	e8 c0 f8 ff ff       	call   80106910 <mappages>
80107050:	83 c4 10             	add    $0x10,%esp
80107053:	85 c0                	test   %eax,%eax
80107055:	78 61                	js     801070b8 <copyuvm+0xc8>
80107057:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010705d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107060:	76 46                	jbe    801070a8 <copyuvm+0xb8>
80107062:	8b 45 08             	mov    0x8(%ebp),%eax
80107065:	31 c9                	xor    %ecx,%ecx
80107067:	89 fa                	mov    %edi,%edx
80107069:	e8 22 f8 ff ff       	call   80106890 <walkpgdir>
8010706e:	85 c0                	test   %eax,%eax
80107070:	74 61                	je     801070d3 <copyuvm+0xe3>
80107072:	8b 00                	mov    (%eax),%eax
80107074:	a8 01                	test   $0x1,%al
80107076:	74 4e                	je     801070c6 <copyuvm+0xd6>
80107078:	89 c3                	mov    %eax,%ebx
8010707a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010707f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107085:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107088:	e8 33 b4 ff ff       	call   801024c0 <kalloc>
8010708d:	85 c0                	test   %eax,%eax
8010708f:	89 c6                	mov    %eax,%esi
80107091:	75 8d                	jne    80107020 <copyuvm+0x30>
80107093:	83 ec 0c             	sub    $0xc,%esp
80107096:	ff 75 e0             	pushl  -0x20(%ebp)
80107099:	e8 02 fe ff ff       	call   80106ea0 <freevm>
8010709e:	83 c4 10             	add    $0x10,%esp
801070a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801070a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ae:	5b                   	pop    %ebx
801070af:	5e                   	pop    %esi
801070b0:	5f                   	pop    %edi
801070b1:	5d                   	pop    %ebp
801070b2:	c3                   	ret    
801070b3:	90                   	nop
801070b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070b8:	83 ec 0c             	sub    $0xc,%esp
801070bb:	56                   	push   %esi
801070bc:	e8 4f b2 ff ff       	call   80102310 <kfree>
801070c1:	83 c4 10             	add    $0x10,%esp
801070c4:	eb cd                	jmp    80107093 <copyuvm+0xa3>
801070c6:	83 ec 0c             	sub    $0xc,%esp
801070c9:	68 ba 7c 10 80       	push   $0x80107cba
801070ce:	e8 bd 92 ff ff       	call   80100390 <panic>
801070d3:	83 ec 0c             	sub    $0xc,%esp
801070d6:	68 a0 7c 10 80       	push   $0x80107ca0
801070db:	e8 b0 92 ff ff       	call   80100390 <panic>

801070e0 <uva2ka>:
801070e0:	55                   	push   %ebp
801070e1:	31 c9                	xor    %ecx,%ecx
801070e3:	89 e5                	mov    %esp,%ebp
801070e5:	83 ec 08             	sub    $0x8,%esp
801070e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801070eb:	8b 45 08             	mov    0x8(%ebp),%eax
801070ee:	e8 9d f7 ff ff       	call   80106890 <walkpgdir>
801070f3:	8b 00                	mov    (%eax),%eax
801070f5:	c9                   	leave  
801070f6:	89 c2                	mov    %eax,%edx
801070f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070fd:	83 e2 05             	and    $0x5,%edx
80107100:	05 00 00 00 80       	add    $0x80000000,%eax
80107105:	83 fa 05             	cmp    $0x5,%edx
80107108:	ba 00 00 00 00       	mov    $0x0,%edx
8010710d:	0f 45 c2             	cmovne %edx,%eax
80107110:	c3                   	ret    
80107111:	eb 0d                	jmp    80107120 <copyout>
80107113:	90                   	nop
80107114:	90                   	nop
80107115:	90                   	nop
80107116:	90                   	nop
80107117:	90                   	nop
80107118:	90                   	nop
80107119:	90                   	nop
8010711a:	90                   	nop
8010711b:	90                   	nop
8010711c:	90                   	nop
8010711d:	90                   	nop
8010711e:	90                   	nop
8010711f:	90                   	nop

80107120 <copyout>:
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 1c             	sub    $0x1c,%esp
80107129:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010712c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010712f:	8b 7d 10             	mov    0x10(%ebp),%edi
80107132:	85 db                	test   %ebx,%ebx
80107134:	75 40                	jne    80107176 <copyout+0x56>
80107136:	eb 70                	jmp    801071a8 <copyout+0x88>
80107138:	90                   	nop
80107139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107140:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107143:	89 f1                	mov    %esi,%ecx
80107145:	29 d1                	sub    %edx,%ecx
80107147:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010714d:	39 d9                	cmp    %ebx,%ecx
8010714f:	0f 47 cb             	cmova  %ebx,%ecx
80107152:	29 f2                	sub    %esi,%edx
80107154:	83 ec 04             	sub    $0x4,%esp
80107157:	01 d0                	add    %edx,%eax
80107159:	51                   	push   %ecx
8010715a:	57                   	push   %edi
8010715b:	50                   	push   %eax
8010715c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010715f:	e8 3c d6 ff ff       	call   801047a0 <memmove>
80107164:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107167:	83 c4 10             	add    $0x10,%esp
8010716a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
80107170:	01 cf                	add    %ecx,%edi
80107172:	29 cb                	sub    %ecx,%ebx
80107174:	74 32                	je     801071a8 <copyout+0x88>
80107176:	89 d6                	mov    %edx,%esi
80107178:	83 ec 08             	sub    $0x8,%esp
8010717b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010717e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107184:	56                   	push   %esi
80107185:	ff 75 08             	pushl  0x8(%ebp)
80107188:	e8 53 ff ff ff       	call   801070e0 <uva2ka>
8010718d:	83 c4 10             	add    $0x10,%esp
80107190:	85 c0                	test   %eax,%eax
80107192:	75 ac                	jne    80107140 <copyout+0x20>
80107194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010719c:	5b                   	pop    %ebx
8010719d:	5e                   	pop    %esi
8010719e:	5f                   	pop    %edi
8010719f:	5d                   	pop    %ebp
801071a0:	c3                   	ret    
801071a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ab:	31 c0                	xor    %eax,%eax
801071ad:	5b                   	pop    %ebx
801071ae:	5e                   	pop    %esi
801071af:	5f                   	pop    %edi
801071b0:	5d                   	pop    %ebp
801071b1:	c3                   	ret    
