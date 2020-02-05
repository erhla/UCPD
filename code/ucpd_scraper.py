import bs4
import pandas as pd
from selenium import webdriver
import time
import re

driver = webdriver.Firefox(executable_path = 'C:/Users/erhla/Documents/GitHub/ah-hoc/geckodriver.exe')

def url_to_soup(url):
    driver.get(url)
    time.sleep(3)
    html = driver.page_source
    return bs4.BeautifulSoup(html, 'html5lib')

def make_target_url(start_date, end_date, record_type):
    s_spt = str.split(start_date, "/")
    e_spt = str.split(end_date, "/")
    if record_type == 'traffic':
        url_frag = 'trafficStops'
    elif record_type == 'interview':
        url_frag = 'fieldInterviews'
    elif record_type == 'incident':
        url_frag = 'incidentReport'    
    base_url = 'https://incidentreports.uchicago.edu/' + url_frag + 'Archive.php?startDate='
    return base_url + s_spt[0] + '%2F' + s_spt[1] + '%2F' + s_spt[2] + '&endDate=' + e_spt[0] + '%2F' + e_spt[1] + '%2F' + e_spt[2]

def process_soup(soup, record_type):
    tables = soup.find_all('table')
    days = tables[0].find_all('tr')
    d_list = []
    for day in days[1:]:
        if day.find_all('td')[0].text.strip()[0:2] == 'No':
            pass
        else:
            entries = day.find_all('td')
            d = {}
            d["Date"] = entries[0].text.strip()
            d["Location"] = entries[1].text.strip()
            if record_type == 'traffic':
                d["Race"] = entries[2].text.strip()
                d["Gender"] = entries[3].text.strip()
                d["IDOT Classification"] = entries[4].text.strip()
                d["Reason for Stop"] = entries[5].text.strip()
                d["Citations/Violations"] = entries[6].text.strip()
                d["Disposition"] = entries[7].text.strip()
                d["Search"] = entries[8].text.strip()
            elif record_type == 'interview':
                d["Initiated By"] = entries[2].text.strip()
                d["Race"] = entries[3].text.strip()
                d["Gender"] = entries[4].text.strip()
                d["Reason for Stop"] = entries[5].text.strip()
                d["Disposition"] = entries[6].text.strip()
                d["Search"] = entries[7].text.strip()
            elif record_type == 'incident':
                d["Reported"] = entries[2].text.strip()
                d["Occured"] = entries[3].text.strip()
                d["Comments"] = entries[4].text.strip()
                d["Disposition"] = entries[5].text.strip()
                d["UCPDI"] = entries[6].text.strip()
            d_list.append(d)
    return d_list

def process_date_range(start_date, end_date, record_type):
    master_ls = []
    cur_url = make_target_url(start_date, end_date, record_type)
    soup = url_to_soup(cur_url)
    page_cnt = soup.find('ul', {"class": "pager"}).find("li", {"class":"page-count"}).text.strip()
    total_page_num = re.findall(r'[0-9]+', page_cnt)[1]
    master_ls.extend(process_soup(soup, record_type))
    for i in range(1, int(total_page_num)):
        soup = url_to_soup(cur_url + '&offset=' + str(i*5))
        master_ls.extend(process_soup(soup, record_type))
    return master_ls

def main(start_date, end_date, record_type, file_name):
    #ex) main('11/01/2019', '12/06/2019', 'incident', 'incident.csv')
    master_ls = process_date_range(start_date, end_date, record_type)
    df = pd.DataFrame(master_ls)
    df.to_csv('C:/Users/erhla/Documents/GitHub/UCPD/' + record_type + '/' + file_name)
    return df
    
def run_all(start_date, end_date):
    types = ['incident', 'interview', 'traffic']
    file_name = start_date[0:2] + start_date[3:5] + start_date[6:10] + '_to_' + end_date[0:2] + end_date[3:5] + end_date[6:10] + '.csv'
    for one_type in types:
        main(start_date, end_date, one_type, file_name)
        


