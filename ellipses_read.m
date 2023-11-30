folder_path= "C:\Users\maria\OneDrive\Desktop\heart_mri\Normal ellipses2\"%change Hyper ellipses2\"for hyperplasia
myFiles = dir(fullfile(folder_path,'*.png'));
for i = 1 : length(myFiles)
       filename = strcat(folder_path,myFiles(i).name);
       I{1,i} = imread(filename);
end
dataCell{i}=readtable(filePath);