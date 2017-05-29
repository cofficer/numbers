function [ data ] = delete_artifact_Numbers( artifacts,data )
%takes artifacts which should be removed from data.trial and data.time
%and removes the samples.


%Find the indices of artifacts, add one so that there is no + 
onset_artifacts= artifacts-data.sampleinfo(1);

%If there is a 0 add 1;
idx_0 = onset_artifacts==0;
onset_artifacts(idx_0)=1;

%Insert NaNs for each artfifact
for iart = 1:size(onset_artifacts,1)
    
    
   %insert nans for all the artifacts
   data.time{1}(onset_artifacts(iart,1):onset_artifacts(iart,2))   = NaN;
   
   data.trial{1}(:,onset_artifacts(iart,1):onset_artifacts(iart,2))   = NaN;
   
   
    
end

%Get nan indeces
indNanTrl = isnan(data.trial{1}(1,:));

%remove all the nan values
data.time{1}(indNanTrl)=[];


data.trial{1}(:,indNanTrl)=[];

end

