++++++++++++++++++++++++++++++++++++++++++++		c1v44 : ASCII code of comma
>++++++++++++++++++++++++++++++++			c2v32 : ASCII code of space
>++++++++++++++++					c3v11 : quantity of numbers to be calculated
>							c4v0  : zeroth Fibonacci number (will not be printed)
>+							c5v1  : first Fibonacci number
<<							c3    : loop counter
[							block : loop to print (i)th number and calculate next one
>>							c5    : the number to be printed

							block : divide c5 by 10 (preserve c5)
>							c6v0  : service zero
>++++++++++						c7v10 : divisor
<<							c5    : back to dividend
[->+>-[>+>>]>[+[-<+>]>+>>]<<<<<<]			c5v0  : divmod algo; results in 0 n d_n%d n%d n/d
>[<+>-]							c5    : move dividend back to c5 and clear c6
>[-]							c7v0  : clear c7

>>							block : c9 can have two digits; divide it by ten again
>++++++++++						c10v10: divisor
<							c9    : back to dividend
[->-[>+>>]>[+[-<+>]>+>>]<<<<<]				c9v0  : another divmod algo; results in 0 d_n%d n%d n/d
>[-]							c10v0 : clear c10
>>[++++++++++++++++++++++++++++++++++++++++++++++++.[-]]c12v0 : print nonzero n/d (first digit) and clear c12
<[++++++++++++++++++++++++++++++++++++++++++++++++.[-]] c11v0 : print nonzero n%d (second digit) and clear c11

<<<++++++++++++++++++++++++++++++++++++++++++++++++.[-]	c8v0  : print any n%d (last digit) and clear c8
<<<<<<<.>.                                              c1c2  : print comma and space
							block : actually calculate next Fibonacci in c6
>>[>>+<<-]						c4v0  : move c4 to c6 (don't need to preserve it)
>[>+<<+>-]						c5v0  : move c5 to c6 and c4 (need to preserve it)
>[<+>-]							c6v0  : move c6 with sum to c5
<<<-							c3    : decrement loop counter
]
<<++...							c1    : output three dots