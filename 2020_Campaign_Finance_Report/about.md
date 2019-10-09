# About

## Data Source

Data was extracted from fec.gov on 2019-October-8.  All data is current through the end of Q2 (2019-June-30).  Files include:

- All Candidate Summary: top-line summary of each candidate's funding sources, disbursements, and some balance sheet items (e.g. ending cash on hand).  ([additional details](https://www.fec.gov/campaign-finance-data/all-candidates-file-description/))

- Candidate-Committee Linkages: mapping of candidates to committee IDs, plus additional information about each committee (e.g. committee designation).  ([additional details](https://www.fec.gov/campaign-finance-data/all-candidates-file-description/))


## Data Processing

The dashboard includes "2020 presidential campaign candidates."  These are identified as candidates who are linked to at least one 2020 committee that is both the 'principal campaign committee' for the candidate and also type 'P' (presidential campaign committee).

Candidate Lee Mercer was filtered from the data.  Mr. Mercer ran as a Democrat in previous cycles and rolled forward a large sum to the 2020 campaign, but is not actively running and has zero cash on hand.  Including his data would cause distraction because his cumulative funds through 2019 Q2 are much larger than any other Democratic candidate.


## Source Code

R files for this app are available on [Github](https://github.com/cbetterley/shiny/tree/master/2020_Campaign_Finance_Report).