function run_freq(cfgin)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %Created 2018-02-14
  %Run spectral decomposition on all numbers data.
  %load each cfgin
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if strcmp(cfgin.blocktype,'resting')
    freq_numbers(cfgin,1)
  else
    auto_clean = 'cleaned'; %cleaned or auto_task
    if strcmp(auto_clean,'cleaned')
      block=1; %should not matter since cleaned is hardcoded twice. 
      freq_numbers(cfgin,block)
    else
      for block =1:3
        freq_numbers(cfgin,block)
      end
  end
end
