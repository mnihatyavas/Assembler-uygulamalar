; tut03.asm: Dokuz adet * yazdýrma örneði.
;
;$nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; (NOT: Deðiþken adlarý UTF-8 olmalý) 9 adet ardýþýk * sergiler
; *********
;--------------------------------------------------------------------------------------------------------------------------
; ===KAYITÇILAR===
; Bellek bölümleri: data, bss, text ve stack/yýðýn'dýr.
; Yýðýn bölümü, program çalýþmasý esnasýnda çaðrýlan fonksiyon ve metodlara aktarýlan parametreleri içerir.
;
; Harici bellek yanýsýra iþlemci içinde dahili bellek olarak kullanýlan, hýzlý iþlemli, sýnýrlý sayýda kayýtçýlar mevcuttur.
; 32-bit mimaride 10 adet 32-bitlik ve 6 adet 16-bitlik iþlemci kayýtçýsý bulunur.
; Kayýtçýlar 3 katagorilidir: Genel (veri/data, iþaretçi/pointer, endeks), control, bölüm/segment kayýtçýlarý.
;
; Genel veri kayýtçýlarý 4 adet 32-bitli: EAX, EBX, ECX, EDX; 4 adet 16-bitli: AX/Accumulator,BX/Base, CX/Counter,
; DX/Data; 8 adet 8-bitlik: AH/High/Yüksek, AL/Low/Alçak, BH, BL,CH, CL, DH, DL
; AX, DX'le beraber çarpma-bölme gibi büyük matematiksel iþlemlerde birlikte kullanýlabilir.
; BX endeksli veri adreslemelerinde kullanýlýr.
; CX, LOOP döngü komutunda sýfýra kadar geriye sayar.
;
; Genel iþaretçi kayýtçýlarý 3 adet 32-bitli EIP, ESP, EBP ve 3 adet 16-bitlik IP/InstructionPointer, SP/Stack, BP/Base
; CS:IP/CodeSegment birlikte tüm kodlamanýn baþlangýç adresini iþaretler.
; SS:SP/StackSegment birlikte aktüel yýðýn verisini iþaretler.
; SS:BP ile altprograma aktarýlan parametre deðiþkenlerini iþaretler, ayrýca DI:BP/DEstinationIndex, SI:BP/Source.
;
; Genel endeks kayýtçýlarý 2 adet 32-bitli ESI, EDI ve 2 adet 16-bitlik SI/sourceIndex/KaynakEndeksi, DI/Destination/Hedef,
; dizge iþlemlerinde kaynak ve hedef olarak, ayrýca toplama-çýkarmada.
;
; Kontrol kayýtçýlarý 2 adet 32-bitli EIP ve Flags/Bayraklar
; Bayrak bitlerinin herbiri matematik, kýyas, þart iþlemlerinde 0-1 deðer alýr ve kontrol edilirler.
; OF/OverflowFlag/TaþmaBayraðý (iþaretli hesalarda yüksek biti taþarsa 1)
; DF/Direction/Yön (0 ise dizge -taþýma/kýyas- iþlemleri soldan saða, 1 ise saðdan sola yapýlýr)
; IF/Interrupt/Kesinti (0 ise harici çaðýrma etkinsizleþtirilir, 1 ise etkinleþtirilir)
; TF/Trap/tuzak (1 ise DEBUG hata ayýklamada komutlarý sonuna kadar deðil, birer adýmda duraksayarak iþler)
; SF/Sign/Ýþaret (negatif -tamlanan+1- sayýlarsa 1, pozitiflerde 0'dýr)
; ZF/Zero/Sýfýr (iþlem sonucu sýfýrsa 1, deðilse 0'dýr)
; AF/Auxiliary/Yardýmcý (bir byte'lýk iþlem bit-3'ten bit-4'e taþýma yapmýþna 1 olur)
; PF/Parity/Eþitlik (aritmetik iþlem sonucu çift bit ise 0, tek bit ise 1 olur)
; CF/Carry/Taþýma (aritmetik sonuçta ensoldan taþmayý, yada shift/kaydýr ve rotate/dönder son bitini tutar)
;
; Bölüm kayýtçýlarý 3 adet 16-bitli CS/CodeSegment (kodlama baþýnýn adresi), DS/Data, SS/Stack
; Veri saklayan ekstra bölümler ES, FS, GS
;--------------------------------------------------------------------------------------------------------------------------

	section .data
    Mesaj db "(NOT: Deðiþken adlarý UTF-8 olmalý) 9 adet ardýþýk * sergiler", 0xa	; Çýktýya mesaj
    Uzunluk equ $ - Mesaj	; Mesaj uzunluðu
    Yildizlar times 9 db "*"

	section .text
    global _start
_start:
    mov edx, Uzunluk
    mov ecx, Mesaj
    mov ebx,1	; dosya stdout=1, ekran
    mov eax, 4	; sys_write=4, yaz
    int 0x80		; harici kernel çaðýrmasý

    mov edx, 9	; Yýldýzlar uzunluðu
    mov ecx, Yildizlar
    mov ebx, 1
    mov eax, 4
    int 0x80
    mov eax,1	; sys_exit=1, çýk
    int 0x80