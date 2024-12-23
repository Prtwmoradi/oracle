update fcb.t_loanfile aa  
set (aa.C_LOANFILEFIELD_,aa.I_LOANFILEFIELD_) =
 (select C_LOANFILEFIELD_,I_LOANFILEFIELD_ from  sharifi.t_loanfile_400 bb where aa.id=bb.id)
where exists ( select 1 from  sharifi.t_loanfile_400 bb where aa.id=bb.id)