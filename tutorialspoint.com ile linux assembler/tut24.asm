; tut24.asm: Disk dosyas� yarat, a�, yaz, oku, kapat, ekrana yans�t �rne�i.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Dosya yaratildi, yazildi ve kapatildi.
; www.tutorialspoint.com'a ho�geldiniz.
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===DOSYA Y�NET�M�===
; �� standart dosya: 0=stdin (klavyeden veri giri�i), 1=stdout (ekrana ��kt� yazd�rma), 2=stderr (ekrana hata yazd�rma)
; Dosya y�netim �a�r�lar� tablosu:
; %eax Ad                %ebx                  %ecx            %edx
; 2  �atal  sys_fork   struct pt_regs
; 3  oku    sys_read  unsigned int      char *            size_t
; 4  yaz     sys_write  unsigned int     const char *  size_t
; 5   a�      sys_open  const char *     int                   int
; 6   kapa  sys_close  unsigned         int
; 8   yarat  sys_creat   const char *    int                                        ;read-only (0), write-only (1), readwrite(2)
; 19  ara   sys_lseek    unsigned int   off_t                unsiged int  ; g�ncelleme, 0=dosyaba��, 1=akt�elkonum, 2=dosyasonu
;
; �rn. EAX=4/yaz, EBX=1/ekran, ECX=Mesaj, EDX=Uzunluk, call 0x80=Kernel �a�r�s�==> D�nen de�er=EAX
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
; yeni bir dosya yarat
    mov eax, 8
    mov ebx, dosya_ad�
    mov ecx, 0777		; read/okunabilir, write/yaz�labilir, execute/�al��t�r�labilir
    int 0x80

    mov [dosya_tasviri1], eax		; yarat gerid�n�� bilgisi=EAX
; �lk mesaj� yarat�lan dosyaya yaz
    mov edx, Uzunluk1
    mov ecx, Mesaj1
    mov ebx, [dosya_tasviri1]
    mov eax,4
    int 0x80

; Dosyay� kapat
    mov eax, 6
    mov ebx, [dosya_tasviri1]
    int 0x80

; Dosya i�lemlerini ekrana yans�t
    mov eax, 4
    mov ebx, 1
    mov ecx, Mesaj2
    mov edx, Uzunluk2
    int 0x80

; ��eri�i okumak i�in dosyay� a�
    mov eax, 5
    mov ebx, dosya_ad�
    mov ecx, 0	; readonly eri�im
    mov edx, 0777	; read, write, execute
    int 0x80

    mov [dosya_tasviri2], eax	; Dosya a��� gerid�n���=EAX
; Dosya i�eriklerini oku
    mov eax, 3
    mov ebx, [dosya_tasviri2]
    mov ecx, bilgi
    mov edx, 40
    int 0x80

; Dosyay� tekrar kapat
    mov eax, 6
    mov ebx, [dosya_tasviri2]
    int 0x80

; bilgi i�eri�ini ekrana yans�t
    mov eax, 4
    mov ebx, 1
    mov ecx, bilgi
    mov edx, 40
    int 0x80

    mov eax,1	; 1=��k
    int 0x80

	section .data
    dosya_ad� db "nihat.txt"
    Mesaj1 db "www.tutorialspoint.com'a ho�geldiniz."
    Uzunluk1 equ $-Mesaj1
    Mesaj2 db "Dosya yarat�ld�, yaz�ld� ve kapat�ld�.", 0xa
    Uzunluk2 equ $-Mesaj2

	section .bss
    dosya_tasviri1 resb 1
    dosya_tasviri2 resb 1
    bilgi resb 40