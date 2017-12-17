## See LICENSE file for license details

## utils ##
try {namespace delete ActiveCore} on error {} {}
namespace eval ActiveCore {

	proc reset {} {
		__gplc_reset
	}

	proc isnumeric {value} {
	    if {![catch {expr {abs($value)}}]} {
	        return 1
	    }
	    set value [string trimleft $value 0]
	    if {![catch {expr {abs($value)}}]} {
	        return 1
	    }
	    return 0
	}

	proc _accum_param {param} {
		if {[isnumeric $param] == 1} {
			if {$param == 0} {
				set width 1
			} else {
				set width [getimmlength $param]
			}
			__gplc_acc_param_c [expr $width - 1] 0 [expr $param + 0]
		} else {
			__gplc_acc_param_v_rd $param
		}
	}

	proc WARNING {code} {
		puts ActiveCore\ Warning!\ Message:\ $code
	}

	proc CRITICAL_WARNING {code} {
		puts ActiveCore\ Critical\ warning!\ Message:\ $code
	}

	proc ERROR {code} {
		puts ActiveCore\ Error!\ Error\ message:\ $code
		error ActiveCore\ interrupted\ due\ to\ error!
	}

	proc debug_set {} {
		__gplc_debug_set
	}

	proc debug_clr {} {
		__gplc_debug_clr
	}

	proc getimmlength {imm} {
    	set imm [expr $imm + 0]
    	if {$imm == 0} {
    		return 1
    	} else {
    		expr [expr {int([expr {floor([expr {log($imm)/log(2)}])}])} + 1]
    	}
	}

	proc verif_nogen {name} {
		if {[regexp {gen} $name]} {
			ERROR No\ gen\ in\ user\ names\ allowed!
		}
	}

	proc expr_1op {opcode op} {
		__gplc_acc_param_clr
		_accum_param $op
		__gplc_acc_param_string $opcode
		__gplc_call op
	}

	proc expr_2op {opcode op1 op2} {
		__gplc_acc_param_clr
		_accum_param $op1
		_accum_param $op2
		__gplc_acc_param_string $opcode
		__gplc_call op
	}

	proc expr_3op {opcode op1 op2 op3} {
		__gplc_acc_param_clr
		_accum_param $op1
		_accum_param $op2
		_accum_param $op3
		__gplc_acc_param_string $opcode
		__gplc_call op
	}

	proc export {language filename} {
		pipe::export
		rtl::export $language $filename
	}
}

proc _acc_index {index} {
	if {[llength $index] > 2} {
		ActiveCore::ERROR Range\ is\ incorrect!
	}
	if {[llength $index] == 1} {
		if {[ActiveCore::isnumeric [lindex $index 0]] == 1} {
			__gplc_acc_index_c [lindex $index 0]
		} else {
			__gplc_acc_index_v [lindex $index 0]
		}
	} else {
		if {[ActiveCore::isnumeric [lindex $index 0]] == 1} {
			if {[ActiveCore::isnumeric [lindex $index 1]] == 1} {
				__gplc_acc_range_cc [lindex $index 0] [lindex $index 1]
			} else {
				__gplc_acc_range_cv [lindex $index 0] [lindex $index 1]
			}
		} else {
			if {[ActiveCore::isnumeric [lindex $index 1]] == 1} {
				__gplc_acc_range_vc [lindex $index 0] [lindex $index 1]
			} else {
				__gplc_acc_range_vv [lindex $index 0] [lindex $index 1]
			}
		}
	}
}

proc initval {dimensions value} {
	_acc_index $dimensions
	ActiveCore::_accum_param $value
	__gplc_call initval
}

proc s= {target source} {
	if {[ActiveCore::isnumeric $target] == 1} {
		ActiveCore::ERROR Target\ $target\ is\ numeric!
	}
	ActiveCore::_accum_param $source
	__gplc_acc_param_v_wr $target
	__gplc_call assign
}

proc c- {op} {
	ActiveCore::expr_1op "c-" $op
}

proc s+ {op1 op2} {
	ActiveCore::expr_2op "s+" $op1 $op2
}

proc s- {op1 op2} {
	ActiveCore::expr_2op "s-" $op1 $op2
}

proc sx {op1 op2} {
	ActiveCore::expr_2op "sx" $op1 $op2
}

proc s/ {op1 op2} {
	ActiveCore::expr_2op "s/" $op1 $op2
}

proc s>> {op1 op2} {
	ActiveCore::expr_2op "s>>" $op1 $op2
}

proc s>>> {op1 op2} {
	ActiveCore::expr_2op "s>>>" $op1 $op2
}

proc s<< {op1 op2} {
	ActiveCore::expr_2op "s<<" $op1 $op2
}

proc s! {op} {
	ActiveCore::expr_1op "s!" $op
}

proc s&& {op1 op2} {
	ActiveCore::expr_2op "s&&" $op1 $op2
}

proc s|| {op1 op2} {
	ActiveCore::expr_2op "s||" $op1 $op2
}

proc s> {op1 op2} {
	ActiveCore::expr_2op "s>" $op1 $op2
}

proc s< {op1 op2} {
	ActiveCore::expr_2op "s<" $op1 $op2
}

proc s>= {op1 op2} {
	ActiveCore::expr_2op "s>=" $op1 $op2
}

proc s<= {op1 op2} {
	ActiveCore::expr_2op "s<=" $op1 $op2
}

proc s== {op1 op2} {
	ActiveCore::expr_2op "s==" $op1 $op2
}

proc s!= {op1 op2} {
	ActiveCore::expr_2op "s!=" $op1 $op2
}

proc s=== {op1 op2} {
	ActiveCore::expr_2op "s===" $op1 $op2
}

proc s!== {op1 op2} {
	ActiveCore::expr_2op "s!==" $op1 $op2
}

proc s~ {op} {
	ActiveCore::expr_1op "s~" $op
}

proc s& {op1 op2} {
	ActiveCore::expr_2op "s&" $op1 $op2
}

proc s| {op1 op2} {
	ActiveCore::expr_2op "s|" $op1 $op2
}

proc s^ {op1 op2} {
	ActiveCore::expr_2op "s^" $op1 $op2
}

proc s^~ {op1 op2} {
	ActiveCore::expr_2op "s^~" $op1 $op2
}

proc indexed {op index} {
	if {[llength $index] > 2} {
		ActiveCore::ERROR Index\ $index\ of\ operand\ $op\ is\ incorrect!
	} else {
		if {[llength $index] == 1} {
			ActiveCore::expr_2op "indexed" $op $index
		} else {
			ActiveCore::expr_3op "ranged" $op [lindex $index 0] [lindex $index 1]
		}
	}	
}

proc begif {condition} {
	__gplc_acc_param_clr
	ActiveCore::_accum_param $condition
	__gplc_call begif
}

proc begnif {condition} {
	begif [s! $condition]
}

proc begelsif {condition} {
	__gplc_acc_param_clr
	ActiveCore::_accum_param $condition
	__gplc_call begelsif
}

proc begelse {} {
	__gplc_call begelse
}

proc endif {} {
	__gplc_call endif
}

proc begwhile {condition} {
	__gplc_acc_param_clr
	ActiveCore::_accum_param $condition
	__gplc_call begwhile
}

proc endwhile {} {
	__gplc_call endwhile
}

proc cnct {ops} {
	__gplc_acc_param_clr
	foreach op $ops {
		ActiveCore::_accum_param $op
	}
	__gplc_acc_param_string "cnct"
	__gplc_call op
}

proc zeroext {op size} {
	if {[ActiveCore::isnumeric $size] == 0} {
		ActiveCore::ERROR size\ cannot\ be\ variable!
	}
	__gplc_acc_param_clr
	ActiveCore::_accum_param $op
	__gplc_acc_param_uint $size
	__gplc_call zeroext 
}

proc signext {op size} {
	if {[ActiveCore::isnumeric $size] == 0} {
		ActiveCore::ERROR size\ cannot\ be\ variable!
	}
	__gplc_acc_param_clr
	ActiveCore::_accum_param $op
	__gplc_acc_param_uint $size
	__gplc_call signext 
}

proc ActiveCore_Reset {} {
	rtl::reset
	ActiveCore::reset
}

source [file join $MLIP_PATH activecore config.tcl]
