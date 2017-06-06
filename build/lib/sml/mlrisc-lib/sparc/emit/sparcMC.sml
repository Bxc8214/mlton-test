(*
 * WARNING: This file was automatically generated by MDLGen (v3.1)
 * from the machine description file "sparc/sparc.mdl".
 * DO NOT EDIT this file directly
 *)


functor SparcMCEmitter(structure Instr : SPARCINSTR
                       structure MLTreeEval : MLTREE_EVAL (* where T = Instr.T *)
                                              where type T.Basis.cond = Instr.T.Basis.cond
                                                and type T.Basis.div_rounding_mode = Instr.T.Basis.div_rounding_mode
                                                and type T.Basis.ext = Instr.T.Basis.ext
                                                and type T.Basis.fcond = Instr.T.Basis.fcond
                                                and type T.Basis.rounding_mode = Instr.T.Basis.rounding_mode
                                                and type T.Constant.const = Instr.T.Constant.const
                                                and type ('s,'r,'f,'c) T.Extension.ccx = ('s,'r,'f,'c) Instr.T.Extension.ccx
                                                and type ('s,'r,'f,'c) T.Extension.fx = ('s,'r,'f,'c) Instr.T.Extension.fx
                                                and type ('s,'r,'f,'c) T.Extension.rx = ('s,'r,'f,'c) Instr.T.Extension.rx
                                                and type ('s,'r,'f,'c) T.Extension.sx = ('s,'r,'f,'c) Instr.T.Extension.sx
                                                and type T.I.div_rounding_mode = Instr.T.I.div_rounding_mode
                                                and type T.Region.region = Instr.T.Region.region
                                                and type T.ccexp = Instr.T.ccexp
                                                and type T.fexp = Instr.T.fexp
                                                (* and type T.labexp = Instr.T.labexp *)
                                                and type T.mlrisc = Instr.T.mlrisc
                                                and type T.oper = Instr.T.oper
                                                and type T.rep = Instr.T.rep
                                                and type T.rexp = Instr.T.rexp
                                                and type T.stm = Instr.T.stm
                       structure Stream : INSTRUCTION_STREAM 
                       structure CodeString : CODE_STRING
                      ) : INSTRUCTION_EMITTER =
struct
   structure I = Instr
   structure C = I.C
   structure Constant = I.Constant
   structure T = I.T
   structure S = Stream
   structure P = S.P
   structure W = Word32
   
   (* Sparc is big endian *)
   
   fun error msg = MLRiscErrorMsg.error("SparcMC",msg)
   fun makeStream _ =
   let infix && || << >> ~>>
       val op << = W.<<
       val op >> = W.>>
       val op ~>> = W.~>>
       val op || = W.orb
       val op && = W.andb
       val itow = W.fromInt
       fun emit_bool false = 0w0 : W.word
         | emit_bool true = 0w1 : W.word
       val emit_int = itow
       fun emit_word w = w
       fun emit_label l = itow(Label.addrOf l)
       fun emit_labexp le = itow(MLTreeEval.valueOf le)
       fun emit_const c = itow(Constant.valueOf c)
       val loc = ref 0
   
       (* emit a byte *)
       fun eByte b =
       let val i = !loc in loc := i + 1; CodeString.update(i,b) end
   
       (* emit the low order byte of a word *)
       (* note: fromLargeWord strips the high order bits! *)
       fun eByteW w =
       let val i = !loc
           val w = W.toLargeWord w
       in loc := i + 1; CodeString.update(i,Word8.fromLargeWord w) end
   
       fun doNothing _ = ()
       fun fail _ = raise Fail "MCEmitter"
       fun getAnnotations () = error "getAnnotations"
   
       fun pseudoOp pOp = P.emitValue{pOp=pOp, loc= !loc,emit=eByte}
   
       fun init n = (CodeString.init n; loc := 0)
   
   
   fun eWord32 w = 
       let val b8 = w
           val w = w >> 0wx8
           val b16 = w
           val w = w >> 0wx8
           val b24 = w
           val w = w >> 0wx8
           val b32 = w
       in 
          ( eByteW b32; 
            eByteW b24; 
            eByteW b16; 
            eByteW b8 )
       end
   fun emit_GP r = itow (CellsBasis.physicalRegisterNum r)
   and emit_FP r = itow (CellsBasis.physicalRegisterNum r)
   and emit_Y r = itow (CellsBasis.physicalRegisterNum r)
   and emit_PSR r = itow (CellsBasis.physicalRegisterNum r)
   and emit_FSR r = itow (CellsBasis.physicalRegisterNum r)
   and emit_CC r = itow (CellsBasis.physicalRegisterNum r)
   and emit_MEM r = itow (CellsBasis.physicalRegisterNum r)
   and emit_CTRL r = itow (CellsBasis.physicalRegisterNum r)
   and emit_CELLSET r = itow (CellsBasis.physicalRegisterNum r)
   fun emit_load (I.LDSB) = (0wx9 : Word32.word)
     | emit_load (I.LDSH) = (0wxA : Word32.word)
     | emit_load (I.LDUB) = (0wx1 : Word32.word)
     | emit_load (I.LDUH) = (0wx2 : Word32.word)
     | emit_load (I.LD) = (0wx0 : Word32.word)
     | emit_load (I.LDX) = (0wxB : Word32.word)
     | emit_load (I.LDD) = (0wx3 : Word32.word)
   and emit_store (I.STB) = (0wx5 : Word32.word)
     | emit_store (I.STH) = (0wx6 : Word32.word)
     | emit_store (I.ST) = (0wx4 : Word32.word)
     | emit_store (I.STX) = (0wxE : Word32.word)
     | emit_store (I.STD) = (0wx7 : Word32.word)
   and emit_fload (I.LDF) = (0wx20 : Word32.word)
     | emit_fload (I.LDDF) = (0wx23 : Word32.word)
     | emit_fload (I.LDQF) = (0wx22 : Word32.word)
     | emit_fload (I.LDFSR) = (0wx21 : Word32.word)
     | emit_fload (I.LDXFSR) = (0wx21 : Word32.word)
   and emit_fstore (I.STF) = (0wx24 : Word32.word)
     | emit_fstore (I.STDF) = (0wx27 : Word32.word)
     | emit_fstore (I.STFSR) = (0wx25 : Word32.word)
   and emit_arith (I.AND) = (0wx1 : Word32.word)
     | emit_arith (I.ANDCC) = (0wx11 : Word32.word)
     | emit_arith (I.ANDN) = (0wx5 : Word32.word)
     | emit_arith (I.ANDNCC) = (0wx15 : Word32.word)
     | emit_arith (I.OR) = (0wx2 : Word32.word)
     | emit_arith (I.ORCC) = (0wx12 : Word32.word)
     | emit_arith (I.ORN) = (0wx6 : Word32.word)
     | emit_arith (I.ORNCC) = (0wx16 : Word32.word)
     | emit_arith (I.XOR) = (0wx3 : Word32.word)
     | emit_arith (I.XORCC) = (0wx13 : Word32.word)
     | emit_arith (I.XNOR) = (0wx7 : Word32.word)
     | emit_arith (I.XNORCC) = (0wx17 : Word32.word)
     | emit_arith (I.ADD) = (0wx0 : Word32.word)
     | emit_arith (I.ADDCC) = (0wx10 : Word32.word)
     | emit_arith (I.TADD) = (0wx20 : Word32.word)
     | emit_arith (I.TADDCC) = (0wx30 : Word32.word)
     | emit_arith (I.TADDTV) = (0wx22 : Word32.word)
     | emit_arith (I.TADDTVCC) = (0wx32 : Word32.word)
     | emit_arith (I.SUB) = (0wx4 : Word32.word)
     | emit_arith (I.SUBCC) = (0wx14 : Word32.word)
     | emit_arith (I.TSUB) = (0wx21 : Word32.word)
     | emit_arith (I.TSUBCC) = (0wx31 : Word32.word)
     | emit_arith (I.TSUBTV) = (0wx23 : Word32.word)
     | emit_arith (I.TSUBTVCC) = (0wx33 : Word32.word)
     | emit_arith (I.UMUL) = (0wxA : Word32.word)
     | emit_arith (I.UMULCC) = (0wx1A : Word32.word)
     | emit_arith (I.SMUL) = (0wxB : Word32.word)
     | emit_arith (I.SMULCC) = (0wx1B : Word32.word)
     | emit_arith (I.UDIV) = (0wxE : Word32.word)
     | emit_arith (I.UDIVCC) = (0wx1E : Word32.word)
     | emit_arith (I.SDIV) = (0wxF : Word32.word)
     | emit_arith (I.SDIVCC) = (0wx1F : Word32.word)
     | emit_arith (I.MULX) = (0wx9 : Word32.word)
     | emit_arith (I.SDIVX) = (0wx2D : Word32.word)
     | emit_arith (I.UDIVX) = (0wxD : Word32.word)
   and emit_shift (I.SLL) = (0wx25, 0wx0)
     | emit_shift (I.SRL) = (0wx26, 0wx0)
     | emit_shift (I.SRA) = (0wx27, 0wx0)
     | emit_shift (I.SLLX) = (0wx25, 0wx1)
     | emit_shift (I.SRLX) = (0wx26, 0wx1)
     | emit_shift (I.SRAX) = (0wx27, 0wx1)
   and emit_farith1 (I.FiTOs) = (0wxC4 : Word32.word)
     | emit_farith1 (I.FiTOd) = (0wxC8 : Word32.word)
     | emit_farith1 (I.FiTOq) = (0wxCC : Word32.word)
     | emit_farith1 (I.FsTOi) = (0wxD1 : Word32.word)
     | emit_farith1 (I.FdTOi) = (0wxD2 : Word32.word)
     | emit_farith1 (I.FqTOi) = (0wxD3 : Word32.word)
     | emit_farith1 (I.FsTOd) = (0wxC9 : Word32.word)
     | emit_farith1 (I.FsTOq) = (0wxD5 : Word32.word)
     | emit_farith1 (I.FdTOs) = (0wxC6 : Word32.word)
     | emit_farith1 (I.FdTOq) = (0wxCE : Word32.word)
     | emit_farith1 (I.FqTOs) = (0wxC7 : Word32.word)
     | emit_farith1 (I.FqTOd) = (0wxCB : Word32.word)
     | emit_farith1 (I.FMOVs) = (0wx1 : Word32.word)
     | emit_farith1 (I.FNEGs) = (0wx5 : Word32.word)
     | emit_farith1 (I.FABSs) = (0wx9 : Word32.word)
     | emit_farith1 (I.FMOVd) = error "FMOVd"
     | emit_farith1 (I.FNEGd) = error "FNEGd"
     | emit_farith1 (I.FABSd) = error "FABSd"
     | emit_farith1 (I.FMOVq) = error "FMOVq"
     | emit_farith1 (I.FNEGq) = error "FNEGq"
     | emit_farith1 (I.FABSq) = error "FABSq"
     | emit_farith1 (I.FSQRTs) = (0wx29 : Word32.word)
     | emit_farith1 (I.FSQRTd) = (0wx2A : Word32.word)
     | emit_farith1 (I.FSQRTq) = (0wx2B : Word32.word)
   and emit_farith2 (I.FADDs) = (0wx41 : Word32.word)
     | emit_farith2 (I.FADDd) = (0wx42 : Word32.word)
     | emit_farith2 (I.FADDq) = (0wx43 : Word32.word)
     | emit_farith2 (I.FSUBs) = (0wx45 : Word32.word)
     | emit_farith2 (I.FSUBd) = (0wx46 : Word32.word)
     | emit_farith2 (I.FSUBq) = (0wx47 : Word32.word)
     | emit_farith2 (I.FMULs) = (0wx49 : Word32.word)
     | emit_farith2 (I.FMULd) = (0wx4A : Word32.word)
     | emit_farith2 (I.FMULq) = (0wx4B : Word32.word)
     | emit_farith2 (I.FsMULd) = (0wx69 : Word32.word)
     | emit_farith2 (I.FdMULq) = (0wx6E : Word32.word)
     | emit_farith2 (I.FDIVs) = (0wx4D : Word32.word)
     | emit_farith2 (I.FDIVd) = (0wx4E : Word32.word)
     | emit_farith2 (I.FDIVq) = (0wx4F : Word32.word)
   and emit_fcmp (I.FCMPs) = (0wx51 : Word32.word)
     | emit_fcmp (I.FCMPd) = (0wx52 : Word32.word)
     | emit_fcmp (I.FCMPq) = (0wx53 : Word32.word)
     | emit_fcmp (I.FCMPEs) = (0wx55 : Word32.word)
     | emit_fcmp (I.FCMPEd) = (0wx56 : Word32.word)
     | emit_fcmp (I.FCMPEq) = (0wx57 : Word32.word)
   and emit_branch (I.BN) = (0wx0 : Word32.word)
     | emit_branch (I.BE) = (0wx1 : Word32.word)
     | emit_branch (I.BLE) = (0wx2 : Word32.word)
     | emit_branch (I.BL) = (0wx3 : Word32.word)
     | emit_branch (I.BLEU) = (0wx4 : Word32.word)
     | emit_branch (I.BCS) = (0wx5 : Word32.word)
     | emit_branch (I.BNEG) = (0wx6 : Word32.word)
     | emit_branch (I.BVS) = (0wx7 : Word32.word)
     | emit_branch (I.BA) = (0wx8 : Word32.word)
     | emit_branch (I.BNE) = (0wx9 : Word32.word)
     | emit_branch (I.BG) = (0wxA : Word32.word)
     | emit_branch (I.BGE) = (0wxB : Word32.word)
     | emit_branch (I.BGU) = (0wxC : Word32.word)
     | emit_branch (I.BCC) = (0wxD : Word32.word)
     | emit_branch (I.BPOS) = (0wxE : Word32.word)
     | emit_branch (I.BVC) = (0wxF : Word32.word)
   and emit_rcond (I.RZ) = (0wx1 : Word32.word)
     | emit_rcond (I.RLEZ) = (0wx2 : Word32.word)
     | emit_rcond (I.RLZ) = (0wx3 : Word32.word)
     | emit_rcond (I.RNZ) = (0wx5 : Word32.word)
     | emit_rcond (I.RGZ) = (0wx6 : Word32.word)
     | emit_rcond (I.RGEZ) = (0wx7 : Word32.word)
   and emit_cc (I.ICC) = (0wx0 : Word32.word)
     | emit_cc (I.XCC) = (0wx2 : Word32.word)
   and emit_fbranch (I.FBN) = (0wx0 : Word32.word)
     | emit_fbranch (I.FBNE) = (0wx1 : Word32.word)
     | emit_fbranch (I.FBLG) = (0wx2 : Word32.word)
     | emit_fbranch (I.FBUL) = (0wx3 : Word32.word)
     | emit_fbranch (I.FBL) = (0wx4 : Word32.word)
     | emit_fbranch (I.FBUG) = (0wx5 : Word32.word)
     | emit_fbranch (I.FBG) = (0wx6 : Word32.word)
     | emit_fbranch (I.FBU) = (0wx7 : Word32.word)
     | emit_fbranch (I.FBA) = (0wx8 : Word32.word)
     | emit_fbranch (I.FBE) = (0wx9 : Word32.word)
     | emit_fbranch (I.FBUE) = (0wxA : Word32.word)
     | emit_fbranch (I.FBGE) = (0wxB : Word32.word)
     | emit_fbranch (I.FBUGE) = (0wxC : Word32.word)
     | emit_fbranch (I.FBLE) = (0wxD : Word32.word)
     | emit_fbranch (I.FBULE) = (0wxE : Word32.word)
     | emit_fbranch (I.FBO) = (0wxF : Word32.word)
   and emit_fsize (I.S) = (0wx4 : Word32.word)
     | emit_fsize (I.D) = (0wx6 : Word32.word)
     | emit_fsize (I.Q) = (0wx7 : Word32.word)
   fun opn {i} = 
       let 
(*#line 478.11 "sparc/sparc.mdl"*)
           fun hi22 w = (itow w) ~>> 0wxA

(*#line 479.11 "sparc/sparc.mdl"*)
           fun lo10 w = ((itow w) && 0wx3FF)
       in 
          (case i of
            I.REG rs2 => error "opn"
          | I.IMMED i => itow i
          | I.LAB l => itow (MLTreeEval.valueOf l)
          | I.LO l => lo10 (MLTreeEval.valueOf l)
          | I.HI l => hi22 (MLTreeEval.valueOf l)
          )
       end
   and rr {op1, rd, op3, rs1, rs2} = 
       let val rs1 = emit_GP rs1
           val rs2 = emit_GP rs2
       in eWord32 ((op1 << 0wx1E) + ((rd << 0wx19) + ((op3 << 0wx13) + ((rs1 << 0wxE) + rs2))))
       end
   and ri {op1, rd, op3, rs1, simm13} = 
       let val rs1 = emit_GP rs1
       in eWord32 ((op1 << 0wx1E) + ((rd << 0wx19) + ((op3 << 0wx13) + ((rs1 << 0wxE) + ((simm13 && 0wx1FFF) + 0wx2000)))))
       end
   and rix {op1, op3, r, i, d} = 
       (case i of
         I.REG rs2 => rr {op1=op1, op3=op3, rs1=r, rs2=rs2, rd=d}
       | _ => ri {op1=op1, op3=op3, rs1=r, rd=d, simm13=opn {i=i}}
       )
   and rir {op1, op3, r, i, d} = 
       let val d = emit_GP d
       in rix {op1=op1, op3=op3, r=r, i=i, d=d}
       end
   and rif {op1, op3, r, i, d} = 
       let val d = emit_FP d
       in rix {op1=op1, op3=op3, r=r, i=i, d=d}
       end
   and load {l, r, i, d} = 
       let val l = emit_load l
       in rir {op1=0wx3, op3=l, r=r, i=i, d=d}
       end
   and store {s, r, i, d} = 
       let val s = emit_store s
       in rir {op1=0wx3, op3=s, r=r, i=i, d=d}
       end
   and fload {l, r, i, d} = 
       let val l = emit_fload l
       in rif {op1=0wx3, op3=l, r=r, i=i, d=d}
       end
   and fstore {s, r, i, d} = 
       let val s = emit_fstore s
       in rif {op1=0wx3, op3=s, r=r, i=i, d=d}
       end
   and sethi {rd, imm22} = 
       let val rd = emit_GP rd
           val imm22 = emit_int imm22
       in eWord32 ((rd << 0wx19) + ((imm22 && 0wx3FFFFF) + 0wx1000000))
       end
   and NOP {} = eWord32 0wx1000000
   and unimp {const22} = 
       let val const22 = emit_int const22
       in eWord32 const22
       end
   and delay {nop} = (if nop
          then (NOP {})
          else ())
   and arith {a, r, i, d} = 
       let val a = emit_arith a
       in rir {op1=0wx2, op3=a, r=r, i=i, d=d}
       end
   and shiftr {rd, op3, rs1, x, rs2} = 
       let val rs2 = emit_GP rs2
       in eWord32 ((rd << 0wx19) + ((op3 << 0wx13) + ((rs1 << 0wxE) + ((x << 0wxC) + (rs2 + 0wx80000000)))))
       end
   and shifti {rd, op3, rs1, x, cnt} = eWord32 ((rd << 0wx19) + ((op3 << 0wx13) + ((rs1 << 0wxE) + ((x << 0wxC) + ((cnt && 0wx3F) + 0wx80002000)))))
   and shift {s, r, i, d} = 
       let val s = emit_shift s
           val r = emit_GP r
           val d = emit_GP d
       in 
          let 
(*#line 517.13 "sparc/sparc.mdl"*)
              val (op3, x) = s
          in 
             (case i of
               I.REG rs2 => shiftr {op3=op3, rs1=r, rs2=rs2, rd=d, x=x}
             | _ => shifti {op3=op3, rs1=r, cnt=opn {i=i}, rd=d, x=x}
             )
          end
       end
   and save {r, i, d} = rir {op1=0wx2, op3=0wx3C, r=r, i=i, d=d}
   and restore {r, i, d} = rir {op1=0wx2, op3=0wx3D, r=r, i=i, d=d}
   and bicc {a, b, disp22} = 
       let val a = emit_bool a
           val b = emit_branch b
       in eWord32 ((a << 0wx1D) + ((b << 0wx19) + ((disp22 && 0wx3FFFFF) + 0wx800000)))
       end
   and fbfcc {a, b, disp22} = 
       let val a = emit_bool a
           val b = emit_fbranch b
       in eWord32 ((a << 0wx1D) + ((b << 0wx19) + ((disp22 && 0wx3FFFFF) + 0wx1800000)))
       end
   and call {disp30} = eWord32 ((disp30 && 0wx3FFFFFFF) + 0wx40000000)
   and jmpl {r, i, d} = rir {op1=0wx2, op3=0wx38, r=r, i=i, d=d}
   and jmp {r, i} = rix {op1=0wx2, op3=0wx38, r=r, i=i, d=0wx0}
   and ticcr {op1, rd, op3, rs1, cc, rs2} = 
       let val rs1 = emit_GP rs1
           val cc = emit_cc cc
           val rs2 = emit_GP rs2
       in eWord32 ((op1 << 0wx1E) + ((rd << 0wx19) + ((op3 << 0wx13) + ((rs1 << 0wxE) + ((cc << 0wxB) + rs2)))))
       end
   and ticci {op1, rd, op3, rs1, cc, sw_trap} = 
       let val rs1 = emit_GP rs1
           val cc = emit_cc cc
       in eWord32 ((op1 << 0wx1E) + ((rd << 0wx19) + ((op3 << 0wx13) + ((rs1 << 0wxE) + ((cc << 0wxB) + ((sw_trap && 0wx7F) + 0wx2000))))))
       end
   and ticcx {op1, op3, cc, r, i, d} = 
       (case i of
         I.REG rs2 => ticcr {op1=op1, op3=op3, cc=cc, rs1=r, rs2=rs2, rd=d}
       | _ => ticci {op1=op1, op3=op3, cc=cc, rs1=r, rd=d, sw_trap=opn {i=i}}
       )
   and ticc {t, cc, r, i} = 
       let val t = emit_branch t
       in ticcx {op1=0wx2, d=t, op3=0wx3A, cc=cc, r=r, i=i}
       end
   and rdy {d} = 
       let val d = emit_GP d
       in eWord32 ((d << 0wx19) + 0wx81400000)
       end
   and wdy {r, i} = rix {op1=0wx2, op3=0wx30, r=r, i=i, d=0wx0}
   and fop_1 {d, a, r} = eWord32 ((d << 0wx19) + ((a << 0wx5) + (r + 0wx81A00000)))
   and fop1 {a, r, d} = 
       let val a = emit_farith1 a
           val r = emit_FP r
           val d = emit_FP d
       in fop_1 {a=a, r=r, d=d}
       end
   and fdouble {a, r, d} = 
       let val a = emit_farith1 a
           val r = emit_FP r
           val d = emit_FP d
       in 
          ( fop_1 {a=a, r=r, d=d}; 
            fop_1 {a=0wx1, r=r + 0wx1, d=d + 0wx1})
       end
   and fquad {a, r, d} = 
       let val a = emit_farith1 a
           val r = emit_FP r
           val d = emit_FP d
       in 
          ( fop_1 {a=a, r=r, d=d}; 
            fop_1 {a=0wx1, r=r + 0wx1, d=d + 0wx1}; 
            fop_1 {a=0wx1, r=r + 0wx2, d=d + 0wx2}; 
            fop_1 {a=0wx1, r=r + 0wx3, d=d + 0wx3})
       end
   and fop2 {d, r1, a, r2} = 
       let val d = emit_FP d
           val r1 = emit_FP r1
           val a = emit_farith2 a
           val r2 = emit_FP r2
       in eWord32 ((d << 0wx19) + ((r1 << 0wxE) + ((a << 0wx5) + (r2 + 0wx81A00000))))
       end
   and fcmp {rs1, opf, rs2} = 
       let val rs1 = emit_FP rs1
           val opf = emit_fcmp opf
           val rs2 = emit_FP rs2
       in eWord32 ((rs1 << 0wxE) + ((opf << 0wx5) + (rs2 + 0wx81A80000)))
       end
   and cmovr {op3, rd, cc2, cond, cc1, cc0, rs2} = eWord32 ((op3 << 0wx18) + ((rd << 0wx13) + ((cc2 << 0wx12) + ((cond << 0wxE) + ((cc1 << 0wxC) + ((cc0 << 0wxB) + (rs2 + 0wx80000000)))))))
   and cmovi {op3, rd, cc2, cond, cc1, cc0, simm11} = eWord32 ((op3 << 0wx18) + ((rd << 0wx13) + ((cc2 << 0wx12) + ((cond << 0wxE) + ((cc1 << 0wxC) + ((cc0 << 0wxB) + ((simm11 && 0wx7FF) + 0wx80002000)))))))
   and cmov {op3, cond, cc2, cc1, cc0, i, rd} = 
       (case i of
         I.REG rs2 => cmovr {op3=op3, cond=cond, rs2=emit_GP rs2, rd=rd, cc0=cc0, 
            cc1=cc1, cc2=cc2}
       | _ => cmovi {op3=op3, cond=cond, rd=rd, cc0=cc0, cc1=cc1, cc2=cc2, 
            simm11=opn {i=i}}
       )
   and movicc {b, i, d} = 
       let val b = emit_branch b
           val d = emit_GP d
       in cmov {op3=0wx2C, cond=b, i=i, rd=d, cc2=0wx1, cc1=0wx0, cc0=0wx0}
       end
   and movfcc {b, i, d} = 
       let val b = emit_fbranch b
           val d = emit_GP d
       in cmov {op3=0wx2C, cond=b, i=i, rd=d, cc2=0wx0, cc1=0wx0, cc0=0wx0}
       end
   and fmovicc {sz, b, r, d} = 
       let val sz = emit_fsize sz
           val b = emit_branch b
           val r = emit_FP r
           val d = emit_FP d
       in cmovr {op3=0wx2C, cond=b, rs2=r, rd=d, cc2=0wx1, cc1=0wx0, cc0=0wx0}
       end
   and fmovfcc {sz, b, r, d} = 
       let val sz = emit_fsize sz
           val b = emit_fbranch b
           val r = emit_FP r
           val d = emit_FP d
       in cmovr {op3=0wx2C, cond=b, rs2=r, rd=d, cc2=0wx0, cc1=0wx0, cc0=0wx0}
       end
   and movrr {rd, rs1, rcond, rs2} = 
       let val rd = emit_GP rd
           val rs1 = emit_GP rs1
           val rs2 = emit_GP rs2
       in eWord32 ((rd << 0wx19) + ((rs1 << 0wxE) + ((rcond << 0wxA) + (rs2 + 0wx81780000))))
       end
   and movri {rd, rs1, rcond, simm10} = 
       let val rd = emit_GP rd
           val rs1 = emit_GP rs1
       in eWord32 ((rd << 0wx19) + ((rs1 << 0wxE) + ((rcond << 0wxA) + ((simm10 && 0wx3FF) + 0wx81782000))))
       end
   and movr {rcond, r, i, d} = 
       let val rcond = emit_rcond rcond
       in 
          (case i of
            I.REG rs2 => movrr {rcond=rcond, rs1=r, rs2=rs2, rd=d}
          | _ => movri {rcond=rcond, rs1=r, rd=d, simm10=opn {i=i}}
          )
       end

(*#line 596.7 "sparc/sparc.mdl"*)
   fun disp label = (itow ((Label.addrOf label) - ( ! loc))) ~>> 0wx2

(*#line 597.7 "sparc/sparc.mdl"*)
   val r15 = C.Reg CellsBasis.GP 15
   and r31 = C.Reg CellsBasis.GP 31
       fun emitter instr =
       let
   fun emitInstr (I.LOAD{l, d, r, i, mem}) = load {l=l, r=r, i=i, d=d}
     | emitInstr (I.STORE{s, d, r, i, mem}) = store {s=s, r=r, i=i, d=d}
     | emitInstr (I.FLOAD{l, r, i, d, mem}) = fload {l=l, r=r, i=i, d=d}
     | emitInstr (I.FSTORE{s, d, r, i, mem}) = fstore {s=s, r=r, i=i, d=d}
     | emitInstr (I.UNIMP{const22}) = unimp {const22=const22}
     | emitInstr (I.SETHI{i, d}) = sethi {imm22=i, rd=d}
     | emitInstr (I.ARITH{a, r, i, d}) = arith {a=a, r=r, i=i, d=d}
     | emitInstr (I.SHIFT{s, r, i, d}) = shift {s=s, r=r, i=i, d=d}
     | emitInstr (I.MOVicc{b, i, d}) = movicc {b=b, i=i, d=d}
     | emitInstr (I.MOVfcc{b, i, d}) = movfcc {b=b, i=i, d=d}
     | emitInstr (I.MOVR{rcond, r, i, d}) = movr {rcond=rcond, r=r, i=i, d=d}
     | emitInstr (I.FMOVicc{sz, b, r, d}) = fmovicc {sz=sz, b=b, r=r, d=d}
     | emitInstr (I.FMOVfcc{sz, b, r, d}) = fmovfcc {sz=sz, b=b, r=r, d=d}
     | emitInstr (I.Bicc{b, a, label, nop}) = 
       ( bicc {b=b, a=a, disp22=disp label}; 
         delay {nop=nop})
     | emitInstr (I.FBfcc{b, a, label, nop}) = 
       ( fbfcc {b=b, a=a, disp22=disp label}; 
         delay {nop=nop})
     | emitInstr (I.BR{rcond, p, r, a, label, nop}) = error "BR"
     | emitInstr (I.BP{b, p, cc, a, label, nop}) = error "BP"
     | emitInstr (I.JMP{r, i, labs, nop}) = 
       ( jmp {r=r, i=i}; 
         delay {nop=nop})
     | emitInstr (I.JMPL{r, i, d, defs, uses, cutsTo, nop, mem}) = 
       ( jmpl {r=r, i=i, d=d}; 
         delay {nop=nop})
     | emitInstr (I.CALL{defs, uses, label, cutsTo, nop, mem}) = 
       ( call {disp30=disp label}; 
         delay {nop=nop})
     | emitInstr (I.Ticc{t, cc, r, i}) = ticc {t=t, r=r, cc=cc, i=i}
     | emitInstr (I.FPop1{a, r, d}) = 
       (case a of
         I.FMOVd => fdouble {a=I.FMOVs, r=r, d=d}
       | I.FNEGd => fdouble {a=I.FNEGs, r=r, d=d}
       | I.FABSd => fdouble {a=I.FABSs, r=r, d=d}
       | I.FMOVq => fquad {a=I.FMOVs, r=r, d=d}
       | I.FNEGq => fquad {a=I.FNEGs, r=r, d=d}
       | I.FABSq => fquad {a=I.FABSs, r=r, d=d}
       | _ => fop1 {a=a, r=r, d=d}
       )
     | emitInstr (I.FPop2{a, r1, r2, d}) = fop2 {a=a, r1=r1, r2=r2, d=d}
     | emitInstr (I.FCMP{cmp, r1, r2, nop}) = 
       ( fcmp {opf=cmp, rs1=r1, rs2=r2}; 
         delay {nop=nop})
     | emitInstr (I.SAVE{r, i, d}) = save {r=r, i=i, d=d}
     | emitInstr (I.RESTORE{r, i, d}) = restore {r=r, i=i, d=d}
     | emitInstr (I.RDY{d}) = rdy {d=d}
     | emitInstr (I.WRY{r, i}) = wdy {r=r, i=i}
     | emitInstr (I.RET{leaf, nop}) = 
       ( jmp {r=(if leaf
            then r31
            else r15), i=I.IMMED 8}; 
         delay {nop=nop})
     | emitInstr (I.SOURCE{}) = ()
     | emitInstr (I.SINK{}) = ()
     | emitInstr (I.PHI{}) = ()
       in
           emitInstr instr
       end
   
   fun emitInstruction(I.ANNOTATION{i, ...}) = emitInstruction(i)
     | emitInstruction(I.INSTR(i)) = emitter(i)
     | emitInstruction(I.LIVE _)  = ()
     | emitInstruction(I.KILL _)  = ()
   | emitInstruction _ = error "emitInstruction"
   
   in  S.STREAM{beginCluster=init,
                pseudoOp=pseudoOp,
                emit=emitInstruction,
                endCluster=fail,
                defineLabel=doNothing,
                entryLabel=doNothing,
                comment=doNothing,
                exitBlock=doNothing,
                annotation=doNothing,
                getAnnotations=getAnnotations
               }
   end
end
