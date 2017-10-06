function [file_name_new ] = FileNameExam( file_name )
%FileNameExam examimze the file name of input files, if the 
%file name cannot accept by system order, this script will 
%change its name
   
file_name_new = file_name;

% remove space ' ' 
if contains(file_name, ' ') 
    file_name_new = strrep(file_name_new, ' ', '');
end

% remove left barcket '('
if contains(file_name, '(') 
    file_name_new = strrep(file_name_new, '(', '');
end
% remove right bracket ')'
if contains(file_name, ')') 
    file_name_new = strrep(file_name_new, ')', '');
end

% change file name
if ~strcmp(file_name, file_name_new)
    movefile(file_name, file_name_new);
end
end

