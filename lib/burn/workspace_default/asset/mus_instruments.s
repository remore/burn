music_instruments:
@ins:
	.word @env_default,@env_default,@env_default
	.byte $30,$00
	.word @env_vol0,@env_default,@env_default
	.byte $30,$00
	.word @env_vol1,@env_default,@env_default
	.byte $30,$00
	.word @env_vol2,@env_default,@env_default
	.byte $70,$00
	.word @env_vol3,@env_arp0,@env_default
	.byte $70,$00
	.word @env_vol3,@env_default,@env_default
	.byte $30,$00
	.word @env_vol4,@env_default,@env_default
	.byte $30,$00
	.word @env_vol2,@env_default,@env_pitch1
	.byte $30,$00
	.word @env_vol5,@env_default,@env_default
	.byte $30,$00
	.word @env_vol2,@env_default,@env_pitch0
	.byte $30,$00
@env_default:
	.byte $c0,$7f,$00
@env_vol0:
	.byte $cf,$7f,$00
@env_vol1:
	.byte $cf,$c5,$c4,$c3,$c3,$c2,$05,$c1,$09,$c0,$7f,$09
@env_vol2:
	.byte $c6,$c6,$c5,$c4,$c3,$08,$c2,$07,$c1,$0e,$c0,$7f,$0a
@env_vol3:
	.byte $d7,$01,$d0,$01,$c2,$01,$b7,$01,$b1,$01,$af,$01,$a2,$01,$98,$94,$7f,$00
@env_vol4:
	.byte $c8,$c3,$c2,$c1,$04,$c0,$7f,$05
@env_vol5:
	.byte $c5,$c5,$c4,$c4,$c3,$c0,$7f,$05
@env_arp0:
	.byte $b4
@env_arp1:
	.byte $c0,$c0,$c3,$c3,$7f,$00
@env_arp2:
	.byte $c6,$c3,$c0,$7f,$02
@env_arp3:
	.byte $c0,$01,$c4,$01,$c7,$01,$7f,$00
@env_arp4:
	.byte $c6,$c6,$c0,$7f,$02
@env_pitch0:
	.byte $c4,$c0,$c3,$c0,$c2,$c0,$c1,$bb,$b6,$b0,$7f,$00
@env_pitch1:
	.byte $c0,$0a,$c1,$c2,$c3,$c4,$c3,$c2,$c1,$c0,$7f,$02
