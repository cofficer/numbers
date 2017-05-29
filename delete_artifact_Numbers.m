function [ data ] = delete_artifact_Numbers( artifacts,data )
%takes artifacts which should be removed from data.trial and data.time
%and removes the samples.


%Find the indices of artifacts
onset_artifacts= artifacts-data.sampleinfo(1);

%Insert NaNs for each artfifact
for iart = 1:length(onset_artifacts)
    
    
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

