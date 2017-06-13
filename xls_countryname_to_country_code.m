function [ countrycode ] = xls_countryname_to_country_code( country_no, excel_country_names )
% xls_countryname_to_country_code 
%   Takes the number of (in terms of order) of a country in the excel file
%   and finds the corresponding country code in GTAP

countrycode = gtap_regions(strmatch(excel_country_names(country_no),gtap_regions(:,4)),3)

end