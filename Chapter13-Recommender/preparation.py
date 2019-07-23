import os
import re
import csv
import glob

# change working directory of script to enclosing directory
this_directory = os.path.dirname(os.path.abspath(__file__))
os.chdir(this_directory)

data_directory = this_directory + '/netflix-prize-data'
output_file = data_directory + '/netflix-prize-data.csv'

movie_ids = {}
with open(data_directory + '/movie_titles.csv', 'r', encoding = 'iso-8859-1') as movies_file:
    for row in csv.reader(movies_file):
        movie_id = int(row[0])
        title = row[2]
        movie_ids[movie_id] = title

print('Beginning parse...')
customer_id = 0

with open(output_file, 'w+') as outfile:
    writer = csv.writer(outfile)
    writer.writerow(['CustomerID', 'Movie', 'Rating'])
    for filename in glob.glob(data_directory + '/combined_data_*.txt'):
        with open(filename, 'r') as data_file:
            for line in data_file:
                new_id = re.search('[0-9]+(?=:)', line)
                if new_id != None:
                    customer_id = int(new_id.group(0))
                    print('Logging activity of customer %d.' % customer_id)
                else:
                    csv_line = [customer_id] + line.split(',')[:2 ]
                    movie_id = int(csv_line[1])
                    if movie_id in movie_ids:
                        csv_line[1] = movie_ids[movie_id]
                        writer.writerow(csv_line)
