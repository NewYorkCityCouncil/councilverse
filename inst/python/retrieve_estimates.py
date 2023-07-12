import pandas as pd
import numpy as np
from copy import deepcopy 

# uploading BBL population estimates

population_estimates = pd.read_csv('inst/extdata/bbl-population-estimates.csv')

# NYC-level numbers for each demographic

nyc_wide_estimates = pd.read_csv('inst/extdata/nyc-wide_estimates.csv', index_col='NYC')
total_pop_NYC = 8769927 # setting NYC total population (from council_geographies['Total population'].sum())
nyc_wide_estimates['Total population'] = total_pop_NYC

# uploading data for each geography 

council_geographies = pd.read_csv('inst/extdata/council-geographies.csv', index_col='council')
community_geographies = pd.read_csv('inst/extdata/community-geographies.csv', index_col='cd')
schooldist_geographies = pd.read_csv('inst/extdata/schooldist-geographies.csv', index_col='schooldist')
precinct_geographies = pd.read_csv('inst/extdata/precinct-geographies.csv', index_col='policeprct')
neighborhood_geographies = pd.read_csv('inst/extdata/neighborhood-geographies.csv', index_col='nta')
borough_geographies = pd.read_csv('inst/extdata/borough-geographies.csv', index_col='borough')

# all available demographic estimates (variable codes are used by get_demo_estimates() to pull estimates from datasets)
# from https://api.census.gov/data/2021/acs/acs5/profile/variables.html

census_demo_variables = {'DP05_0071PE':'% Hispanic or Latino',
                           'DP05_0076PE':'% Not Hispanic or Latino',
                           'DP05_0039PE':'% American Indian and Alaska Native alone',
                           'DP05_0044PE':'% Asian alone',
                           'DP05_0038PE':'% Black or African American alone',
                           'DP05_0052PE':'% Native Hawaiian and other Pacific Islander alone',
                           'DP05_0037PE':'% White alone',
                           'DP05_0057PE':'% Some other race alone',
                           'DP05_0035PE':'% Two or more races',
                           'DP05_0079PE':'% American Indian and Alaska Native alone, not Hispanic or Latino',
                           'DP05_0080PE':'% Asian alone, not Hispanic or Latino',
                           'DP05_0078PE':'% Black or African American alone, not Hispanic or Latino',
                           'DP05_0081PE':'% Native Hawaiian and other Pacific Islander alone, not Hispanic or Latino',
                           'DP05_0077PE':'% White alone, not Hispanic or Latino',
                           'DP05_0082PE':'% Some other race alone, not Hispanic or Latino',
                           'DP05_0083PE':'% Two or more races, not Hispanic or Latino',
                           'DP05_0002PE':'% Male',
                           'DP05_0003PE':'% Female',
                           'DP05_0019PE':'% Under 18 years',
                           'DP05_0021PE':'% Over 18 years',
                           'DP05_0024PE':'% 65 years and over',
                           'DP02_0053E':'% Enrolled in school (3 years and over)',
                           'DP02_0054E':'% Enrolled in nursery school, preschool',
                           'DP02_0055E':'% Enrolled in Kindergarten',
                           'DP02_0056E':'% Enrolled in grades 1-8',
                           'DP02_0057E':'% Enrolled in grades 9-12',
                           'DP02_0058E':'% Enrolled in college, graduate school',
                           'DP02_0061E':'% Adults with no high school diploma',
                           'DP02_0062E':'% Adults with high school diploma (includes equivalency)',
                           'DP02_0068E':'% Adults with Bachelor\'s degree or higher',
                           'DP03_0002E':'% In the labor force (16 and older)',
                           'DP03_0007E':'% Not in the labor force (16 and older)',
                           'DP03_0004E':'% Employed (16 and older)',
                           'DP03_0005E':'% Unemployed (16 and older)',
                           'DP02_0090E':'% Born in the US',
                           'DP02_0093E':'% Born in Puerto Rico, U.S. Island areas, or abroad to American parents)',
                           'DP02_0094PE':'% Foreign born',
                           'DP02_0096E':'% Naturalized US citizen (foreign born)',
                           'DP02_0097E':'% Not a US citizen (foreign born)',
                           'DP02_0113E':'% Speak only English at home (5 years and older)',
                           'DP02_0115E':'% Speak English less than "very well" (5 years and older)',
                           'DP02_0116E':'% Speak Spanish at home (5 years and older)',
                           'DP02_0072E':'% With a disability (civilian, noninstitutionalized)',
                           'DP02_0074E':'% With a disability, under 18 (civilian, noninstitutionalized)',
                           'DP02_0076E':'% With a disability, over 18-65 (civilian, noninstitutionalized)',
                           'DP02_0078E':'% With a disability, over 65 (civilian, noninstitutionalized)',
                           'DP03_0096E':'% With health insurance (civilian, noninstitutionalized)',
                           'DP03_0097E':'% With private health insurance (civilian, noninstitutionalized)',
                           'DP03_0098E':'% With public coverage (civilian, noninstitutionalized)',
                           'DP03_0099E':'% With no health insurance coverage (civilian, noninstitutionalized)',
                           'DP03_0019E':'% Drive to work (workers 16 and older)',
                           'DP03_0020E':'% Carpool to work (workers 16 and older)',
                           'DP03_0021E':'% Take public transit to work (workers 16 and older)',
                           'DP03_0022E':'% Walk to work (workers 16 and older)',
                           'DP03_0024E':'% Work from home (workers 16 and older)',
                           'DP05_0005PE':'% Under 5 years',
                           'DP05_0006PE':'% 5 to 9 years',
                           'DP05_0007PE':'% 10 to 14 years',
                           'DP05_0008PE':'% 15 to 19 years',
                           'DP05_0009PE':'% 20 to 24 years',
                           'DP05_0010PE':'% 25 to 34 years',
                           'DP05_0011PE':'% 35 to 44 years',
                           'DP05_0012PE':'% 45 to 54 years',
                           'DP05_0013PE':'% 55 to 59 years',
                           'DP05_0014PE':'% 60 to 64 years',
                           'DP05_0015PE':'% 65 to 74 years',
                           'DP05_0016PE':'% 75 to 84 years',
                           'DP05_0017PE':'% 85 years and over'
                          }

####################################

# outputs a df with estimates, MOEs, and CVs for selected variables 

def get_demo_estimates(var_code_list, geo, polygons = False, download = False, demo_dict = census_demo_variables):
    
# var_code_list: input a list of variable codes  
# geo: input a string for the desired geographic boundaries (options: council, policeprct, schooldist, cd, nta, schooldist, borough, nyc)
# polygons: input True to add geometry column
# download: input True to download output df
# demo_dict: the dict of available variable codes

    if geo not in ['council', 'policeprct', 'schooldist', 'cd', 'nta', 'schooldist', 'borough', 'nyc']: # error if geo not available
        raise ValueError('Estimates for the geography type ' + geo + ' are not available')
    
    request_df = pd.DataFrame() # empty dataframe
    
    # based on input for geo, sets which df the data will be pulled from
    
    if geo == 'council':
        request_df = deepcopy(council_geographies)
    elif geo == 'policeprct':
        request_df = deepcopy(precinct_geographies)
    elif geo == 'schooldist':
        request_df = deepcopy(schooldist_geographies)
    elif geo == 'cd':
        request_df = deepcopy(community_geographies)
    elif geo == 'nta':
        request_df = deepcopy(neighborhood_geographies)
    elif geo == 'schooldist':
        request_df = deepcopy(schooldist_geographies)
    elif geo == 'borough':
        request_df = deepcopy(borough_geographies)
    elif geo == 'nyc':
        request_df = deepcopy(nyc_wide_estimates)
            
    col_name_list = [] # list of columns that will be in final version of request_df
    
    for var_code in var_code_list: # for each inputted variable code
        
        if var_code not in demo_dict.keys(): # error if var_code not available
            raise ValueError('Estimates for the variable code ' + var_code + ' are not available')
            
        col_name = demo_dict[var_code] # column name will be the full name of the variable, which is accesed in demo_dict by var_code
            
        col_name_list.append(col_name) # add estimate column
        col_name_list.append(col_name + ' MOE') # add margin of error column
        col_name_list.append(col_name + ' CV') # add coefficient of variation column
                
    col_name_list.append('Total population') # add Total population column
    
    if polygons and geo != 'nyc': # adding geometry column for any geography except 'nyc'
        
        geometries = request_df['geometry']
        
        request_df = request_df[col_name_list] # subsetting request_df to columns added to col_name_list
        request_df['geometry'] = geometries # adding geometries
        
    else:
        
        request_df = request_df[col_name_list] # subsetting request_df to columns added to col_name_list
        
    if download: # downloading as a csv 
        
        request_df.to_csv('demographic-estimates_by_' + geo + '.csv')
            
    return request_df

####################################

# outputs a df with population estimates and residential units by BBL, along with various geographies

def get_bbl_estimates(pop_est_df = population_estimates):
    
    return pop_est_df

####################################

# outputs the available variables and their census api codes

def view_variables(as_df = True, demo_dict = census_demo_variables):
    
# demo_dict: the dict of available variable codes

    if as_df: # convert demo_dict to a df
        
        variable_df = pd.DataFrame(demo_dict.items(), columns=['var_code', 'var_name']) # df of each code/ variable name pairing 
        variable_df['var_name'] =  variable_df['var_name'].apply(lambda x: x[2:]) # removing % from beginning of variable names
        
        return variable_df
    
    else: # otherwise, just print the pairings out
        
        for key in demo_dict.keys(): 
    
            print(key, ':', demo_dict[key][2:])
        
        return 
