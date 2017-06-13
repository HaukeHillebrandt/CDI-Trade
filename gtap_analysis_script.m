% GTAP ANALYSIS

% clear all
% 
% % specify analysis folder
% 
% cd 'C:\Users\Hauke\Desktop\CDI trade analysis\GTAP_full_database'

%% 1. Data import

% full real file 
% GTAP_data_file = 'Gtap_tariffs.txt';
% 
% % test file. comment out
% % GTAP_data_file = 'test.txt'
% 
% GTAP_data = importfile_array_gtap_tariffs(GTAP_data_file);
% 
% save('GTAP_data.mat', 'GTAP_data', '-v7.3');
% 
% load('GTAP_data.mat')

%% import file with Regions

GTAP_regions = importfile_array_regions('Regions.txt')

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


%% 3. Table info and input specification

% Gtap_tariffs file structure:

% reporter	sector	partner	year	ave             id_regime	id_MethAgg
% ALB       all     ARE     2007	0.060026126     1           1
% ALB       all     ARE     2007	0.0637898418	1           2


% partner  =
% 1	140	XTW	Rest of the World	1
% 1	141	WRD	World	1

partner = {'WRD'};
year = 2011;

% id_regime =
% id_source	id_regime	regime
% 1	1	Bound
% 1	2	MFN
% 1	3	Applied

id_regime = 3;

% id_MethAgg	MethAgg
% 1	Trade weighted by bilateral imports
% 2	Trade weighted by reference group imports
% 3	Simple average
% http://www.macmap.org/SupportMaterials/Methodology.aspx#method_B2

id_MethAgg = 3;

% table{length(GTAP_sector_codes),length(GTAP_country_codes} = [];

%% 4. Create table

tic
table{length(GTAP_country_codes),length(GTAP_sector_codes)} = [];

for i = 1:length(GTAP_country_codes)
    for g = [1:16 18:length(GTAP_sector_codes)]
        
        % saved as matrix
            table_matrix(i,g) = GTAP_data(...            
            ismember(GTAP_data(:,1), GTAP_country_codes(i)) & ... % reporter
            ismember(GTAP_data(:,2), GTAP_sector_codes(g)) & ...sector
            ismember(GTAP_data(:,3), partner) & ...  partner
            ismember([GTAP_data{:,4}]', year) & ... year
            ismember([GTAP_data{:,6}]', id_regime) &... id_regime
            ismember([GTAP_data{:,7}]', id_MethAgg) ... id_MethAgg
            ,5); % tariff column
        
%             GTAP_data(...
%             ismember(GTAP_data, [{GTAP_country_codes(i)} {GTAP_sector_codes(i)} {partner}])  ...
%         )
% %             {year} {id_regime} {id_MethAgg}

    end
end
toc

% Create .mat filename

MAT_FILENAME=sprintf('GTAP_tariffs_table_partner_%s_%d_ID_regime_%d_ID_MethAGG_%d.mat',partner{1},year,id_regime,id_MethAgg)

%Save as mat file
save(MAT_FILENAME,'table_matrix')

% Create .xlsx filename

XLS_FILENAME=sprintf('GTAP_tariffs_table_partner_%s_%d_ID_regime_%d_ID_MethAGG_%d.xlsx',partner{1},year,id_regime,id_MethAgg)

%Save to new xls file

xlswrite(XLS_FILENAME, table_matrix)

xlswrite('Trade final_STRI_Impediments_EU_agr_subsidies_table_commodities_Table_updated_comtrade_updated_more_sources_added_v2_edit.xlsx',table_matrix,'Trade 2017','I42')

