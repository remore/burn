__@__NAME__@__:
	.word @chn0,@chn1,@chn2,@chn3,@chn4,music_instruments
	.byte $03

@chn0:
@chn0_0:
__@__CHANNEL1__@__
@chn0_loop:
@chn0_1:
	.byte $9f
	.byte $fe
	.word @chn0_loop

@chn1:
@chn1_0:
__@__CHANNEL2__@__
@chn1_loop:
@chn1_1:
	.byte $9f
	.byte $fe
	.word @chn1_loop

@chn2:
@chn2_0:
__@__CHANNEL3__@__
	.byte $89
@chn2_loop:
@chn2_1:
	.byte $9f
	.byte $fe
	.word @chn2_loop

@chn3:
@chn3_0:
__@__CHANNEL4__@__
@chn3_loop:
@chn3_1:
	.byte $9f
	.byte $fe
	.word @chn3_loop

@chn4:
@chn4_0:
__@__CHANNEL5__@__
@chn4_loop:
@chn4_1:
	.byte $9f
	.byte $fe
	.word @chn4_loop
