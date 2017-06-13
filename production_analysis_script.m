% GTAP production data ANALYSIS
% Wilujeung sumping di kota bandung

clear all
% 
% % specify analysis folder
% 
cd 'C:\Users\Hauke\Desktop\CDI trade analysis\GTAP_full_database'

%% 1. Data import

%% Import the data

[~, ~, GTAP_prod] = xlsread('C:\Users\Hauke\Desktop\CDI trade analysis\GTAP_full_database\GTAP7_production.xlsx','Sheet1','K3:DT62');
GTAP_prod(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),GTAP_prod)) = {''};


%% import file with Regions

GTAP_regions = importfile_array_regions('Regions.txt');

% Import country names from Excel file
EXCEL_country_names = importfile_array_excel_country_names('Trade final.xlsx','Trade 2016','A42:A68');

% rename 'South Korea' (as called in Excel) to 'Korea Republic of'

EXCEL_country_names{strmatch('South Korea',EXCEL_country_names),1} = 'Korea Republic of';

% Import sector names from Excel file
EXCEL_sector_names = importfile_array_excel_sector_names('Trade final.xlsx','Trade 2016','I41:AY41');

% Import GTAP sector names from text file
GTAP_sector_names = importfile_gtap_sector_names('Sectors.txt', 2, 45);

%% 2. Data manipulation

% find excel_country_names number in gtap_regions and list them in
% countrycodes var

for i=1:length(EXCEL_country_names)
    
    GTAP_country_codes(i,:) = GTAP_regions(strmatch(EXCEL_country_names(i),GTAP_regions(:,4)),3);
    
end

% find excel_sector_names numbers in gtap_sectors_names and list them in
% GTAP_sector_codes var


for i=[1:16 18:length(EXCEL_sector_names)] % 17 = Gas manufacture, distribution - missing from GTAP data
    
    GTAP_sector_codes(i,:) = GTAP_sector_names(strmatch(EXCEL_sector_names(i),GTAP_sector_names(:,3),'exact'),2);
    
end


%% 4. Create table


% Total value

% Total production for sector



% extracts the column number of all CDI countries

for i = 1:length(GTAP_country_codes)
    CDI_countries_production_cols(i) = find(~cellfun(@isempty, (strfind(GTAP_prod(1,:), GTAP_country_codes{i,1}))))

end

% extracts the row number of all CDI sector codes

for i = [1:16 18:length(GTAP_sector_codes)]
    CDI_sector_production_rows(i) = find(~cellfun(@isempty, (strfind(GTAP_prod(:,1), GTAP_sector_codes{i,1}))))
end



% subtracts the CDI countries production from total production for all CDI
% sectors

for i=[1:16 18:length(EXCEL_sector_names)]
   
    Total_production_minus_CDI(:,i) = GTAP_prod{CDI_sector_production_rows(i),end} - sum([GTAP_prod{CDI_sector_production_rows(i), CDI_countries_production_cols}])

end

% QA double check that code above works
% for i=1:length(CDI_countries_production_cols)
%     CDIcountries(i)=GTAP_prod{CDI_sector_production_rows(41), CDI_countries_production_cols(i)}
% end




% % Create .mat filename
% %Save as mat file
save('Total_production_minus_CDI_countries','Total_production_minus_CDI')

% % Create .xlsx filename
% %Save to new xls file
% 

xlswrite('Total_production_minus_CDI_countries',Total_production_minus_CDI)

xlswrite('Trade final_ALL_previous_plus_slovakia_fixed_completely_final_analysis_2017_table_fixed_edit.xlsx',Total_production_minus_CDI,'Trade 2017','I70')