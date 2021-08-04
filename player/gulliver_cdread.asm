	.code
	.bank $069
	.org $559c
l_559c:
          jsr     l5633_105
          lda     $56d8
          sta     <$a1
          lda     $56d9
          sta     <$a2
l_55a9:
          lda     <$a1
          sta     $56d8
          lda     <$a2
          sta     $56d9
          lda     <_al
          sta     $56ce
          stz     <$a3
          jsr     l5628_105
          jsr     scsi_read_sector
          jsr     l5633_105
          stz     <_bl
          lda     #$c0
          sta     <_bh
l55c9_105:
          jsr     l55d7_105
          lda     $56cc
          bne     l_559c
          lda     $56ce
          bne     l55c9_105
          rts     
l55d7_105:
          lda     <$a3
          sta     $56cd
          lsr     A
          lsr     A
          clc     
          adc     <$53
          clc     
          adc     #$02
          tam     #$06
          lda     #$06
          sta     $56cf
          stz     <_bl
          lda     #$c0
          tst     #$03, <$a3
          beq     l55f6_105
          lda     #$d0
l55f6_105:
          sta     <_bh
l55f8_105:
          jsr     scsi_read_sector.next
          lda     $56cc
          bne     l5627_105
          inc     $56cd
          tst     #$03, $56cd
          bne     l5612_105
          tma     #$06
          inc     A
          tam     #$06
          lda     #$c0
          sta     <_bh
l5612_105:
          dec     $56ce
          dec     $56cf
          bne     l55f8_105
          lda     <$a3
          clc     
          adc     #$06
          sta     <$a3
          inc     <$a1
          bne     l5627_105
          inc     <$a2
l5627_105:
          rts     
l5628_105:
          ldx     #$07
l562a_105:
          lda     <_al, X
          sta     $56d0, X
          dex     
          bpl     l562a_105
          rts     
l5633_105:
          ldx     #$07
l5635_105:
          lda     $56d0, X
          sta     <_al, X
          dex     
          bpl     l5635_105
          rts     

scsi_read_sector:
          jsr     scsi_cmd.save
          stz     $56cb
@init:
          jsr     scsi_cmd.init
          bcc     @ready
          jsr     scsi_cmd.flush
          bra     @init
@ready:
          clx     
          ldy     #$14
@retry:
          jsr     scsi_status.get
          and     #$80
          bne     @l1
          dex     
          bne     @retry
          dey     
          bne     @retry
          bra     @init
@l1:
          jsr     scsi_status.get
          cmp     #$d0
          beq     @send
          bra     @l1
scsi_read_sector.next:
          stz     $56cc
          jsr     scsi_cmd.save
@l2:
          jsr     scsi_status.get
          cmp     #$c8
          beq     @read
          cmp     #$d0
          beq     @send
          cmp     #$d8
          beq     @resp
          bra     @l2
@send:
          jsr     scsi_cmd.load
          lda     <_bl
          sta     $56c9
          lda     <_bh
          sta     $56ca
          lda     <_al
          sta     <_dh
          lda     $56cb
          sta     <_al
          jsr     scsi_read.prepare
          jsr     scsi_cmd.send
          lda     $56c9
          sta     <_bl
          lda     $56ca
          sta     <_bh
          rts     
@read:
          jsr     l3e21_248
          bne     @std
          jsr     cd_read_sector.fast
          rts     
@std:
          jsr     cd_read_sector
          rts     
@resp:
          jsr     scsi_cmd.resp
          cmp     #$02
          beq     @err
          rts     
@err:
          jsr     scsi_sense_data
          jsr     scsi_check_suberror
          jsr     scsi_cmd.load
          dec     $56cc
          rts     

	.code
	.bank $0f8
	.org $3a00
l3a00:
          nop     
          jmp     l4000_105
          jmp     l3b0e_248
          jmp     l3b03_248
          jmp     l3ac4_248
l3a0d_248:
          jmp     l3ac0_248
          jmp     l3b21_248
          jmp     l3a61_248
l3a16_248:
          jmp     l3b30_248
          jmp     l3b50_248
          jmp     l3bdb_248
          jmp     l3bfd_248
l3a22_248:
          jsr     l3b9c_248
          lda     $2b80
          sta     $2b7f
          jsr     l3bcf_248
          lda     $2b7f
          sta     $2b81
          bra     l3a22_248
          brk     
          brk     
          bbs7    <_dh, l3a3c_248
          sxy     
l3a3c_248:
          tsb     <$08
          bpl     l3a60_248
          rti     
          bra     l39c3_248
          rti     
          jsr     l0810_255
          tsb     <$02
          ora     [$68, X]
          tam     #$07
          pla     
          rti     
          phx     
          tsx     
          tst     #$10, $2102, X
          beq     l3a64_248
          plx     
          bbr1    <$21, l3a5e_248
          jmp     lffe0_00
l3a5e_248:
          jmp     [$2048]
l3a61_248:
          sei     
l3a62_248:
          bra     l3a62_248
l3a64_248:
          plx     
          pha     
          tma     #$07
          pha     
          cla     
          tam     #$07
          lda     #$3a
          pha     
          lda     #$4a
          pha     
          php     
          jmp     video_reg_l
          pha     
          tma     #$07
          pha     
          cla     
          tam     #$07
          lda     #$3a
          pha     
          lda     #$4a
          pha     
          php     
          jmp     video_reg_l
          pha     
          tma     #$07
          pha     
          cla     
          tam     #$07
          lda     #$3a
          pha     
          lda     #$4a
          pha     
          php     
          jmp     video_reg_l
          bbr1    <$21, l3a5e_248
          jmp     lffe0_00
          pha     
          tma     #$07
          pha     
          cla     
          tam     #$07
          lda     #$3a
          pha     
          lda     #$4a
          pha     
          php     
          jmp     video_reg_l
          pha     
          tma     #$07
          pha     
          cla     
          tam     #$07
          lda     #$3a
          pha     
          lda     #$4a
          pha     
          php     
          jmp     video_reg_l
l3ac0_248:
          smb2    <$21
          bra     l3ac6_248
l3ac4_248:
          rmb2    <$21
l3ac6_248:
          pha     
          phx     
          phy     
          tsx     
          lda     $2104, X
          sta     <$45
          lda     $2105, X
          sta     <$46
          ldy     #$02
          lda     [$45], Y
          sta     $3aeb
          iny     
          lda     [$45], Y
          sta     $3aec
          cla     
          tam     #$07
          bbs2    <$21, l3af7_248
l3ae7_248:
          ply     
          plx     
          pla     
l3aea_248:
          jsr     video_reg_l
          bbs2    <$21, l3afb_248
l3af0_248:
          pha     
          lda     <$47
          tam     #$07
          pla     
          rts     
l3af7_248:
          bsr     l3b03_248
          bra     l3ae7_248
l3afb_248:
          cmp     #$00
          beq     l3af0_248
          bsr     l3b0e_248
          bra     l3aea_248
l3b03_248:
          ldx     #$07
l3b05_248:
          lda     <_al, X
          sta     $3b19, X
          dex     
          bpl     l3b05_248
          rts     
l3b0e_248:
          ldx     #$07
l3b10_248:
          lda     $3b19, X
          sta     <_al, X
          dex     
          bpl     l3b10_248
          rts     
          brk     
          brk     
          brk     
          brk     
          brk     
          brk     
          brk     
          brk     
l3b21_248:
          sta     <_dh
          cla     
          tam     #$07
          jsr     psg_bios
          pha     
          lda     <$47
          tam     #$07
          pla     
          rts     
l3b30_248:
          tsx     
          lda     $2101, X
          sta     <$4c
          lda     $2102, X
          sta     <$4d
          sxy     
          ldy     #$02
          lda     [$4c], Y
          sta     $2b82, X
          iny     
          lda     [$4c], Y
          sta     $2bc2, X
          iny     
          lda     [$4c], Y
          sta     $2c02, X
          rts     
l3b50_248:
          sta     <$4a
          tma     #$04
          pha     
          phx     
          phy     
          tsx     
          lda     $2104, X
          sta     <$4c
          lda     $2105, X
          sta     <$4d
          ldy     #$02
          lda     [$4c], Y
          tax     
          iny     
          lda     [$4c], Y
          pha     
          ldy     $2b82, X
          lda     $2000, Y
          tam     #$04
          pla     
          asl     A
          tay     
          lda     $2bc2, X
          sta     <$4e
          lda     $2c02, X
          adc     #$00
          sta     <$4f
          lda     [$4e], Y
          sta     <$50
          iny     
          lda     [$4e], Y
l3b89_248:
          sta     <$51
          ply     
          plx     
          lda     <$4a
          bsr     l3b99_248
          sta     <$4a
          pla     
          tam     #$04
          lda     <$4a
          rts     
l3b99_248:
          jmp     [$2050]
l3b9c_248:
          ldy     #$00
          jsr     l3a16_248
          tst     #$f8, $3ba6
          rts     
          ldx     $bc3b
          .db     $3b
          .db     $cb
          .db     $3b
          bbs4    <$3b, l3b89_248
          pha     
          tax     
          lda     $267c, X
          sta     <_ah
          txa     
          pla     
          jsr     l3bdb_248
          plx     
          lda     <$00, X
          sta     <_bl
          lda     #$06
l3bc2_248:
          sta     <_dh
          jsr     l3a0d_248
          bit     cd_read
          rts     
          lda     #$01
          bra     l3bc2_248
l3bcf_248:
          ldx     #$01
          jsr     l3bae_248
          lda     <$01
          tam     #$02
          jmp     l4002_105
l3bdb_248:
          tax     
          lda     $267c, X
          sta     <_al
          txa     
          stz     <_ch
          ldx     #$06
l3be6_248:
          asl     A
          rol     <_ch
          dex     
          bne     l3be6_248
          clc     
          adc     #$02
          sta     <_dl
          lda     <_ch
          adc     #$00
          sta     <_ch
          cla     
          adc     #$00
          sta     <_cl
          rts     
l3bfd_248:
          clc     
          adc     <_dl
          sta     <_dl
          lda     <_ch
          adc     #$00
          sta     <_ch
          lda     <_cl
          adc     #$00
          sta     <_cl
          rts     
scsi_status.get:
          lda     cd_port
          and     #$f8
          rts     
; ----------------------------------------------------------------
; SCSI handshake
; ----------------------------------------------------------------
scsi_handshake:
          lda     #$80
          tsb     cd_ctrl
; initiator (the PCE) set /ACK signal to 1
; detect when target set /REQ signal to 0
@l0:
          tst     #$40, cd_port
          bne     @l0
; initiator (the PCE) set /ACK signal to 0
@l1:
          trb     cd_ctrl
          rts     
; ----------------------------------------------------------------
; begin SCSI command transfer
; ----------------------------------------------------------------
scsi_cmd.init:
          lda     #$81
          sta     cd_cmd
          tst     #$80, cd_port
          bne     @busy
          sta     cd_port
          clc     
          rts     
@busy:
          sec     
          rts     
; ----------------------------------------------------------------
; prepare read command buffer
;   in: _al - base address to use (see CD_BASE documentation in the Hu7 CD BIOS manual)
;       _dh - sector count
;       _dl - sector address (L)
;       _cl - sector address (M)
;       _ch - sector address (H)
;  out: $224c - command buffer
;         _bl - LSB of the command buffer address ($4c)
;         _bh - MSB of the command buffer address = ($22)
; ----------------------------------------------------------------
scsi_read.prepare:
          lda     <_al
          asl     A
          clc     
          adc     <_al
          tax     
          ldy     #$06
          cla     
          sta     $224c, Y
          dey     
          lda     <_dh
          sta     $224c, Y
          dey     
          lda     <_dl
          clc     
          adc     recbase0_l, X
          sta     $224c, Y
          dey     
          lda     <_ch
          adc     recbase0_m, X
          sta     $224c, Y
          dey     
          lda     <_cl
          adc     recbase0_h, X
          sta     $224c, Y
          dey     
          lda     #$08
          sta     $224c, Y
          lda     #$06
          sta     $224c
          lda     #$4c
          sta     <_bl
          lda     #$22
          sta     <_bh
          rts     
; ----------------------------------------------------------------
; send command buffer
; ----------------------------------------------------------------
scsi_cmd.send:
          lda     [_bl]
          tax     
          ldy     #$01
@l0:
          lda     cd_port
          and     #$f8
          cmp     #$d0
          bne     @l0
          lda     [_bl], Y
          iny     
          sta     cd_cmd
          jsr     scsi_handshake
          dex     
          bne     @l0
          rts     
; ----------------------------------------------------------------
; retrieve SCSI Command response
; out: A - ???
; ----------------------------------------------------------------
scsi_cmd.resp:
          phx     
          clx     
l3c96_248:
          lda     cd_port
          and     #$f8
          cmp     #$f8
          beq     l3cad_248
          cmp     #$d8
          beq     l3ca5_248
          bra     l3c96_248
l3ca5_248:
          ldx     cd_cmd
          jsr     scsi_handshake
          bra     l3c96_248
l3cad_248:
          lda     cd_cmd
          jsr     scsi_handshake
l3cb3_248:
          tst     #$80, cd_port
          bne     l3cb3_248
          txa     
          plx     
          rts     
scsi_cmd.flush:
          lda     #$60
          trb     cd_ctrl
          sta     cd_port
          ldx     #$95
@wait:
          lda     #$ed
@delay:
          dec     A
          bne     @delay
          nop     
          nop     
          nop     
          dex     
          bne     @wait
          lda     #$ff
          sta     cd_cmd
          tst     #$40, cd_port
          beq     @done
l3cdc_248:
          jsr     scsi_handshake
l3cdf_248:
          tst     #$40, cd_port
          bne     l3cdc_248
          tst     #$80, cd_port
          bne     l3cdf_248
@done:
          rts     
; ----------------------------------------------------------------
; read n bytes from $1801
;  in: _al - number of bytes to read
; out: _bl - address where the data will be stored
; ----------------------------------------------------------------
cd_read_n:
          lda     cd_port
          and     #$f8
          cmp     #$c8
          bne     cd_read_n
          lda     cd_cmd
          sta     [_bl]
          jsr     scsi_handshake
          inc     <_bl
          bne     l3d03_248
          inc     <_bh
l3d03_248:
          lda     <_al
          bne     l3d09_248
          dec     <_ah
l3d09_248:
          dec     <_al
          lda     <_al
          ora     <_ah
          bne     cd_read_n
          rts     

cmd_request_sense:
          .db $06
          .db $03
          .db $00
          .db $00
          .db $00
          .db $0a
          .db $00
scsi_sense_data_ex:
          jsr     scsi_cmd.flush
; ----------------------------------------------------------------
; request SENSE DATA from cdrom
; out: A - sub error code (b0-3) and class (b4-6)
;      $2256 - buffer where the SENSE DATA will be stored
; ----------------------------------------------------------------
scsi_sense_data:
          jsr     scsi_cmd.init
          bcs     scsi_sense_data_ex
          ldx     #$14
          cly     
@retry:
          jsr     scsi_status.get
          and     #$80
          bne     @loop
          dex     
          bne     @retry
          dey     
          bne     @retry
          bra     scsi_sense_data
@loop:
          jsr     scsi_status.get
          cmp     #$d0
          beq     @send
          cmp     #$c8
          beq     @read
          cmp     #$d8
          beq     @resp
          bra     @loop
; send REQUEST SENSE command
@send:
          lda     #$12
          sta     <_bl
          lda     #$3d
          sta     <_bh
          jsr     scsi_cmd.send
          bra     @loop
; retrieve SENSE DATA and store them at $2256
@read:
          lda     #$56
          sta     <_bl
          lda     #$22
          sta     <_bh
          lda     #$0a
          sta     <_al
          stz     <_ah
          jsr     cd_read_n
          bra     @loop
@resp:
          jsr     scsi_cmd.resp
          cmp     #$00
          bne     scsi_sense_data
; retrieve sub error code and class from SENSE DATA
@suberror:
          lda     $225f
          rts     
; ----------------------------------------------------------------
; Read sector data (2048 bytes) through $1808
; out: _bl - address where the data will be stored
; ----------------------------------------------------------------
cd_read_sector.fast:
          cly     
          ldx     #$07
@l0:
          lda     cd_data
          sta     [_bl], Y
          nop     
          nop     
          nop     
          iny     
          bne     @l0
          inc     <_bh
          dex     
          bne     @l0
@l1:
          lda     cd_data
          sta     [_bl], Y
          nop     
          nop     
          iny     
          cpy     #$f6
          bne     @l1
          php     
          sei     
          lda     cd_data
          sta     [_bl], Y
          iny     
          nop     
          nop     
          nop     
          nop     
          nop     
          lda     cd_data
          plp     
          sta     [_bl], Y
          iny     
          nop     
          nop     
          nop     
          nop     
@l2:
          lda     cd_data
          sta     [_bl], Y
          nop     
          nop     
          nop     
          iny     
          bne     @l2
          inc     <_bh
          cla     
          rts     
; ----------------------------------------------------------------
; read sector data (2048 bytes) through $1801
; out: _bl - address where the data will be stored
; ----------------------------------------------------------------
cd_read_sector:
          cly     
          ldx     #$08
@l0:
          lda     cd_port
          and     #$40
          beq     @l0
          lda     cd_cmd
          sta     [_bl], Y
          lda     #$80
          tsb     cd_ctrl
@l1:
          tst     #$40, cd_port
          bne     @l1
          trb     cd_ctrl
          iny     
          bne     @l0
          inc     <_bh
          dex     
          bne     @l0
          cla     
          rts     
; ----------------------------------------------------------------
; check if the current sub error is fatal
;  in: A - sub error code
; out: A - $00 if the error is unrecoverable, $01 otherwise 
;      Carry flag - set if the error is unrecoverable, cleared otherwise
; ----------------------------------------------------------------
scsi_check_suberror:
          cmp     #$00
          beq     @recoverable
          cmp     #$04
          bne     @others
          bra     @recoverable
@others:
          cmp     #$0b
          beq     @fatal
          cmp     #$0d
          beq     @fatal
          cmp     #$11
          beq     @recoverable
          cmp     #$15
          beq     @recoverable
          cmp     #$16
          beq     @recoverable
          cmp     #$1c
          beq     @fatal
          cmp     #$1d
          beq     @fatal
          cmp     #$20
          beq     @fatal
          cmp     #$21
          beq     @fatal
          cmp     #$22
          beq     @fatal
          cmp     #$25
          beq     @fatal
          cmp     #$2a
          beq     @fatal
          cmp     #$2c
          beq     @fatal
@recoverable:
          lda     #$01
          sec     
          rts     
@fatal:
          cla     
          clc     
          rts     
l3e21_248:
          lda     #$80
          cmp     $fff5
          rts     
          lda     cd_ctrl
          and     bram_lock
          rts     
          lda     #$40
          tsb     cd_ctrl
          rts     
          lda     #$40
          trb     cd_ctrl
          rts     
          lda     #$20
          tsb     cd_ctrl
          rts     
          lda     #$20
          trb     cd_ctrl
          rts     
scsi_cmd.save:
          phx     
          clx     
@l0:
          lda     <_al, X
          sta     $2260, X
          inx     
          cpx     #$08
          bne     @l0
          plx     
          rts     
scsi_cmd.load:
          phx     
          clx     
@l0:
          lda     $2260, X
          sta     <_al, X
          inx     
          cpx     #$08
          bne     @l0
          plx     
          rts     
          cly     
          ldx     #$08
l3e65_248:
          lda     cd_port
          and     #$40
          beq     l3e65_248
          lda     cd_cmd
          sta     $1a00
          lda     #$80
          tsb     cd_ctrl
l3e77_248:
          tst     #$40, cd_port
          bne     l3e77_248
          trb     cd_ctrl
          dey     
          bne     l3e65_248
          dex     
          bne     l3e65_248
          cla     
          rts     
          ldy     #$f6
          ldx     #$08
l3e8c_248:
          lda     cd_data
          sta     $1a00
          nop     
          nop     
          nop     
          nop     
          dey     
          bne     l3e8c_248
          dex     
          bne     l3e8c_248
          php     
          sei     
          lda     cd_data
          sta     $1a00
          nop     
          nop     
          nop     
          nop     
          nop     
          nop     
          nop     
          lda     cd_data
          plp     
          sta     $1a00
          nop     
          nop     
          nop     
          nop     
          nop     
          ldx     #$08
l3eb9_248:
          lda     cd_data
          sta     $1a00
          nop     
          nop     
          nop     
          nop     
          dex     
          bne     l3eb9_248
          cla     
          rts     
          lda     $22a4
          rts     
          stx     cd_data
          sty     cd_data+1
          lda     #$03
          tsb     adpcm_addr_ctrl
          lda     #$01
          trb     adpcm_addr_ctrl
          lda     #$02
          trb     adpcm_addr_ctrl
          rts     
          lda     #$01
          sta     adpcm_dma_ctrl
l3ee7_248:
          tst     #$01, adpcm_dma_ctrl
          bne     l3ee7_248
          cla     
          rts     
          lda     #$01
          sta     adpcm_dma_ctrl
          rts     
          lda     #$02
          sta     adpcm_dma_ctrl
          rts     
          stz     adpcm_dma_ctrl
          rts     
          lda     cd_cmd
          pha     
          jsr     scsi_handshake
          pla     
          rts     
          stx     cd_data
          sty     cd_data+1
          lda     #$08
          tsb     adpcm_addr_ctrl
          lda     adpcm_ram
          ldx     #$04
l3f18_248:
          dex     
          bne     l3f18_248
          lda     #$08
          trb     adpcm_addr_ctrl
          rts     
          stx     cd_data
          sty     cd_data+1
          lda     #$10
          tsb     adpcm_addr_ctrl
          trb     adpcm_addr_ctrl
          rts     
          sta     adpcm_rate
          rts     
          lda     #$40
          tsb     adpcm_addr_ctrl
          rts     
          lda     #$40
          trb     adpcm_addr_ctrl
          rts     
          lda     #$20
          tsb     adpcm_addr_ctrl
          rts     
          lda     #$20
          trb     adpcm_addr_ctrl
          rts     
          lda     #$80
          tsb     adpcm_addr_ctrl
          trb     adpcm_addr_ctrl
          rts     
          lda     #$04
          tsb     cd_ctrl
          rts     
          lda     #$04
          trb     cd_ctrl
          rts     
          lda     #$08
          tsb     cd_ctrl
          rts     
          lda     #$08
          trb     cd_ctrl
          rts     
          lda     adpcm_status
          and     #$8d
          rts     

