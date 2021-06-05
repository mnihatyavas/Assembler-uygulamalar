; tut03.asm: Dokuz adet * yazd�rma �rne�i.
;
;$nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; (NOT: De�i�ken adlar� UTF-8 olmal�) 9 adet ard���k * sergiler
; *********
;--------------------------------------------------------------------------------------------------------------------------
; ===KAYIT�ILAR===
; Bellek b�l�mleri: data, bss, text ve stack/y���n'd�r.
; Y���n b�l�m�, program �al��mas� esnas�nda �a�r�lan fonksiyon ve metodlara aktar�lan parametreleri i�erir.
;
; Harici bellek yan�s�ra i�lemci i�inde dahili bellek olarak kullan�lan, h�zl� i�lemli, s�n�rl� say�da kay�t��lar mevcuttur.
; 32-bit mimaride 10 adet 32-bitlik ve 6 adet 16-bitlik i�lemci kay�t��s� bulunur.
; Kay�t��lar 3 katagorilidir: Genel (veri/data, i�aret�i/pointer, endeks), control, b�l�m/segment kay�t��lar�.
;
; Genel veri kay�t��lar� 4 adet 32-bitli: EAX, EBX, ECX, EDX; 4 adet 16-bitli: AX/Accumulator,BX/Base, CX/Counter,
; DX/Data; 8 adet 8-bitlik: AH/High/Y�ksek, AL/Low/Al�ak, BH, BL,CH, CL, DH, DL
; AX, DX'le beraber �arpma-b�lme gibi b�y�k matematiksel i�lemlerde birlikte kullan�labilir.
; BX endeksli veri adreslemelerinde kullan�l�r.
; CX, LOOP d�ng� komutunda s�f�ra kadar geriye sayar.
;
; Genel i�aret�i kay�t��lar� 3 adet 32-bitli EIP, ESP, EBP ve 3 adet 16-bitlik IP/InstructionPointer, SP/Stack, BP/Base
; CS:IP/CodeSegment birlikte t�m kodlaman�n ba�lang�� adresini i�aretler.
; SS:SP/StackSegment birlikte akt�el y���n verisini i�aretler.
; SS:BP ile altprograma aktar�lan parametre de�i�kenlerini i�aretler, ayr�ca DI:BP/DEstinationIndex, SI:BP/Source.
;
; Genel endeks kay�t��lar� 2 adet 32-bitli ESI, EDI ve 2 adet 16-bitlik SI/sourceIndex/KaynakEndeksi, DI/Destination/Hedef,
; dizge i�lemlerinde kaynak ve hedef olarak, ayr�ca toplama-��karmada.
;
; Kontrol kay�t��lar� 2 adet 32-bitli EIP ve Flags/Bayraklar
; Bayrak bitlerinin herbiri matematik, k�yas, �art i�lemlerinde 0-1 de�er al�r ve kontrol edilirler.
; OF/OverflowFlag/Ta�maBayra�� (i�aretli hesalarda y�ksek biti ta�arsa 1)
; DF/Direction/Y�n (0 ise dizge -ta��ma/k�yas- i�lemleri soldan sa�a, 1 ise sa�dan sola yap�l�r)
; IF/Interrupt/Kesinti (0 ise harici �a��rma etkinsizle�tirilir, 1 ise etkinle�tirilir)
; TF/Trap/tuzak (1 ise DEBUG hata ay�klamada komutlar� sonuna kadar de�il, birer ad�mda duraksayarak i�ler)
; SF/Sign/��aret (negatif -tamlanan+1- say�larsa 1, pozitiflerde 0'd�r)
; ZF/Zero/S�f�r (i�lem sonucu s�f�rsa 1, de�ilse 0'd�r)
; AF/Auxiliary/Yard�mc� (bir byte'l�k i�lem bit-3'ten bit-4'e ta��ma yapm��na 1 olur)
; PF/Parity/E�itlik (aritmetik i�lem sonucu �ift bit ise 0, tek bit ise 1 olur)
; CF/Carry/Ta��ma (aritmetik sonu�ta ensoldan ta�may�, yada shift/kayd�r ve rotate/d�nder son bitini tutar)
;
; B�l�m kay�t��lar� 3 adet 16-bitli CS/CodeSegment (kodlama ba��n�n adresi), DS/Data, SS/Stack
; Veri saklayan ekstra b�l�mler ES, FS, GS
;--------------------------------------------------------------------------------------------------------------------------

	section .data
    Mesaj db "(NOT: De�i�ken adlar� UTF-8 olmal�) 9 adet ard���k * sergiler", 0xa	; ��kt�ya mesaj
    Uzunluk equ $ - Mesaj	; Mesaj uzunlu�u
    Yildizlar times 9 db "*"

	section .text
    global _start
_start:
    mov edx, Uzunluk
    mov ecx, Mesaj
    mov ebx,1	; dosya stdout=1, ekran
    mov eax, 4	; sys_write=4, yaz
    int 0x80		; harici kernel �a��rmas�

    mov edx, 9	; Y�ld�zlar uzunlu�u
    mov ecx, Yildizlar
    mov ebx, 1
    mov eax, 4
    int 0x80
    mov eax,1	; sys_exit=1, ��k
    int 0x80