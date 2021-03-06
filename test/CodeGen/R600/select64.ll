; RUN: llc < %s -march=r600 -mcpu=SI -verify-machineinstrs | FileCheck %s

; CHECK-LABEL: @select0
; i64 select should be split into two i32 selects, and we shouldn't need
; to use a shfit to extract the hi dword of the input.
; CHECK-NOT: S_LSHR_B64
; CHECK: V_CNDMASK
; CHECK: V_CNDMASK
define void @select0(i64 addrspace(1)* %out, i32 %cond, i64 %in) {
entry:
  %0 = icmp ugt i32 %cond, 5
  %1 = select i1 %0, i64 0, i64 %in
  store i64 %1, i64 addrspace(1)* %out
  ret void
}
