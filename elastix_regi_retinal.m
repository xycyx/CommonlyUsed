files = dir()
% Get a logical vector that tells which is a directory.
files(1:2) = []
dir_flags = [files.isdir]
% Extract only those that are directories.
sub_folders = files(dir_flags)

convert_to_dcm = 1;
for file_case = 1 : length(sub_folders)
    fprintf('Sub folder #%d = %s\n', file_case, sub_folders(file_case).name);
    current_path = ['./' sub_folders(file_case).name '/'];
    
    % convert avi to dcm 
    if convert_to_dcm
        files_repeats = dir(current_path);
        files_repeats(1:2) = [];
        dir_flags = [files_repeats.isdir];
        sub_folders_repeats = files_repeats(dir_flags);
        for file_repeat_num = 1 : length(sub_folders_repeats)
            disp(file_repeat_num)
            file_repeat_path = [current_path, sub_folders_repeats(file_repeat_num).name, '/' ];
            file_repeat_list = dir([file_repeat_path '*.avi']);
            for i = 1 : length(file_repeat_list)
                file_read = [file_repeat_path file_repeat_list(i).name];
                avi2dicom(file_read);
            end
            
        end
       
        
    end
    
end