	.code
	.bank $069
	.org $563e
scsi_cmd.send:
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
@l0:
          jsr     scsi_status.get
          and     #$80
          bne     @l1
          dex     
          bne     @l0
          dey     
          bne     @l0
          bra     @init
@l1:
          jsr     scsi_status.get
          cmp     #$d0
          beq     l5680_105
          bra     @l1

unknown:
          stz     $56cc
          jsr     scsi_cmd.save
l566f_105:
          jsr     scsi_status.get
          cmp     #$c8
          beq     l56a7_105
          cmp     #$d0
          beq     l5680_105
          cmp     #$d8
          beq     l56b4_105
          bra     l566f_105
l5680_105:
          jsr     scsi_cmd.load
          lda     <_bl
          sta     $56c9
          lda     <_bh
          sta     $56ca
          lda     <_al
          sta     <_dh
          lda     $56cb
          sta     <_al
          jsr     l3c36_248
          jsr     scsi_cmd.send
          lda     $56c9
          sta     <_bl
          lda     $56ca
          sta     <_bh
          rts     
l56a7_105:
          jsr     l3e21_248
          bne     l56b0_105
          jsr     cd_read
          rts     
l56b0_105:
          jsr     l3db5_248
          rts     
l56b4_105:
          jsr     l3c94_248
          cmp     #$02
          beq     l56bc_105
          rts     
l56bc_105:
          jsr     l3d1c_248
          jsr     l3ddc_248
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
          jmp     lffe0_104
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
          jmp     lffe0_104
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
          jsr     le0d8_104
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
          bit     $e009
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
l3c15_248:
          lda     #$80
          tsb     cd_ctrl
l3c1a_248:
          tst     #$40, cd_port
          bne     l3c1a_248
          trb     cd_ctrl
          rts     
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
l3c36_248:
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
          jsr     l3c15_248
          dex     
          bne     @l0
          rts     
l3c94_248:
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
          jsr     l3c15_248
          bra     l3c96_248
l3cad_248:
          lda     cd_cmd
          jsr     l3c15_248
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
          jsr     l3c15_248
l3cdf_248:
          tst     #$40, cd_port
          bne     l3cdc_248
          tst     #$80, cd_port
          bne     l3cdf_248
@done:
          rts     
l3cec_248:
          lda     cd_port
          and     #$f8
          cmp     #$c8
          bne     l3cec_248
          lda     cd_cmd
          sta     [_bl]
          jsr     l3c15_248
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
          bne     l3cec_248
          rts     
          asl     <$03
          brk     
          brk     
          brk     
          asl     A
          brk     
l3d19_248:
          jsr     scsi_cmd.flush
l3d1c_248:
          jsr     scsi_cmd.init
          bcs     l3d19_248
          ldx     #$14
          cly     
l3d24_248:
          jsr     scsi_status.get
          and     #$80
          bne     l3d33_248
          dex     
          bne     l3d24_248
          dey     
          bne     l3d24_248
          bra     l3d1c_248
l3d33_248:
          jsr     scsi_status.get
          cmp     #$d0
          beq     l3d44_248
          cmp     #$c8
          beq     l3d51_248
          cmp     #$d8
          beq     l3d64_248
          bra     l3d33_248
l3d44_248:
          lda     #$12
          sta     <_bl
          lda     #$3d
          sta     <_bh
          jsr     scsi_cmd.send
          bra     l3d33_248
l3d51_248:
          lda     #$56
          sta     <_bl
          lda     #$22
          sta     <_bh
          lda     #$0a
          sta     <_al
          stz     <_ah
          jsr     l3cec_248
          bra     l3d33_248
l3d64_248:
          jsr     l3c94_248
          cmp     #$00
          bne     l3d1c_248
          lda     $225f
          rts     
cd_read:
          cly     
          ldx     #$07
l3d72_248:
          lda     cd_data
          sta     [_bl], Y
          nop     
          nop     
          nop     
          iny     
          bne     l3d72_248
          inc     <_bh
          dex     
          bne     l3d72_248
l3d82_248:
          lda     cd_data
          sta     [_bl], Y
          nop     
          nop     
          iny     
          cpy     #$f6
          bne     l3d82_248
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
l3da6_248:
          lda     cd_data
          sta     [_bl], Y
          nop     
          nop     
          nop     
          iny     
          bne     l3da6_248
          inc     <_bh
          cla     
          rts     
l3db5_248:
          cly     
          ldx     #$08
l3db8_248:
          lda     cd_port
          and     #$40
          beq     l3db8_248
          lda     cd_cmd
          sta     [_bl], Y
          lda     #$80
          tsb     cd_ctrl
l3dc9_248:
          tst     #$40, cd_port
          bne     l3dc9_248
          trb     cd_ctrl
          iny     
          bne     l3db8_248
          inc     <_bh
          dex     
          bne     l3db8_248
          cla     
          rts     
l3ddc_248:
          cmp     #$00
          beq     l3e1a_248
          cmp     #$04
          bne     l3de6_248
          bra     l3e1a_248
l3de6_248:
          cmp     #$0b
          beq     l3e1e_248
          cmp     #$0d
          beq     l3e1e_248
          cmp     #$11
          beq     l3e1a_248
          cmp     #$15
          beq     l3e1a_248
          cmp     #$16
          beq     l3e1a_248
          cmp     #$1c
          beq     l3e1e_248
          cmp     #$1d
          beq     l3e1e_248
          cmp     #$20
          beq     l3e1e_248
          cmp     #$21
          beq     l3e1e_248
          cmp     #$22
          beq     l3e1e_248
          cmp     #$25
          beq     l3e1e_248
          cmp     #$2a
          beq     l3e1e_248
          cmp     #$2c
          beq     l3e1e_248
l3e1a_248:
          lda     #$01
          sec     
          rts     
l3e1e_248:
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
          jsr     l3c15_248
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

