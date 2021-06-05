; tut24.asm: Disk dosyasý yarat, aç, yaz, oku, kapat, ekrana yansýt örneði.
;
; $nasm -f elf *.asm; ld -m elf_i386 -s -o demo *.o
; $demo
; Dosya yaratildi, yazildi ve kapatildi.
; www.tutorialspoint.com'a hoþgeldiniz.
;----------------------------------------------------------------------------------------------------------------------------------------------
; ===DOSYA YÖNETÝMÝ===
; Üç standart dosya: 0=stdin (klavyeden veri giriþi), 1=stdout (ekrana çýktý yazdýrma), 2=stderr (ekrana hata yazdýrma)
; Dosya yönetim çaðrýlarý tablosu:
; %eax Ad                %ebx                  %ecx            %edx
; 2  çatal  sys_fork   struct pt_regs
; 3  oku    sys_read  unsigned int      char *            size_t
; 4  yaz     sys_write  unsigned int     const char *  size_t
; 5   aç      sys_open  const char *     int                   int
; 6   kapa  sys_close  unsigned         int
; 8   yarat  sys_creat   const char *    int                                        ;read-only (0), write-only (1), readwrite(2)
; 19  ara   sys_lseek    unsigned int   off_t                unsiged int  ; güncelleme, 0=dosyabaþý, 1=aktüelkonum, 2=dosyasonu
;
; Örn. EAX=4/yaz, EBX=1/ekran, ECX=Mesaj, EDX=Uzunluk, call 0x80=Kernel çaðrýsý==> Dönen deðer=EAX
;----------------------------------------------------------------------------------------------------------------------------------------------

	section .text
    global _start
_start:
; yeni bir dosya yarat
    mov eax, 8
    mov ebx, dosya_adý
    mov ecx, 0777		; read/okunabilir, write/yazýlabilir, execute/çalýþtýrýlabilir
    int 0x80

    mov [dosya_tasviri1], eax		; yarat geridönüþ bilgisi=EAX
; Ýlk mesajý yaratýlan dosyaya yaz
    mov edx, Uzunluk1
    mov ecx, Mesaj1
    mov ebx, [dosya_tasviri1]
    mov eax,4
    int 0x80

; Dosyayý kapat
    mov eax, 6
    mov ebx, [dosya_tasviri1]
    int 0x80

; Dosya iþlemlerini ekrana yansýt
    mov eax, 4
    mov ebx, 1
    mov ecx, Mesaj2
    mov edx, Uzunluk2
    int 0x80

; Ýçeriði okumak için dosyayý aç
    mov eax, 5
    mov ebx, dosya_adý
    mov ecx, 0	; readonly eriþim
    mov edx, 0777	; read, write, execute
    int 0x80

    mov [dosya_tasviri2], eax	; Dosya açýþ geridönüþü=EAX
; Dosya içeriklerini oku
    mov eax, 3
    mov ebx, [dosya_tasviri2]
    mov ecx, bilgi
    mov edx, 40
    int 0x80

; Dosyayý tekrar kapat
    mov eax, 6
    mov ebx, [dosya_tasviri2]
    int 0x80

; bilgi içeriðini ekrana yansýt
    mov eax, 4
    mov ebx, 1
    mov ecx, bilgi
    mov edx, 40
    int 0x80

    mov eax,1	; 1=Çýk
    int 0x80

	section .data
    dosya_adý db "nihat.txt"
    Mesaj1 db "www.tutorialspoint.com'a hoþgeldiniz."
    Uzunluk1 equ $-Mesaj1
    Mesaj2 db "Dosya yaratýldý, yazýldý ve kapatýldý.", 0xa
    Uzunluk2 equ $-Mesaj2

	section .bss
    dosya_tasviri1 resb 1
    dosya_tasviri2 resb 1
    bilgi resb 40