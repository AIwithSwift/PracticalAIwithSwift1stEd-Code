# BEGIN acpyimports
import turicreate as tc
from glob import glob
# END acpyimports

# BEGIN acpydatadir
data_dir = 'HAPT/RawData/'
# END acpydatadir

# BEGIN acpyfindlabel
def find_label_for_containing_interval(intervals, index):
    containing_interval = intervals[:, 0][(intervals[:, 1] <= index) & (index <= intervals[:, 2])]
    if len(containing_interval) == 1:
        return containing_interval[0]
# END acpyfindlabel      
    
# Load labels
# BEGIN acpylabels
labels = tc.SFrame.read_csv(data_dir + 'labels.txt', delimiter=' ', header=False, verbose=False)
labels = labels.rename({'X1': 'exp_id', 'X2': 'user_id', 'X3': 'activity_id', 'X4': 'start', 'X5': 'end'})
print(labels)
# END acpylabels

# BEGIN acpyfilesload
acc_files = glob(data_dir + 'acc_*.txt')
gyro_files = glob(data_dir + 'gyro_*.txt')
# END acpyfilesload

# Load data
# BEGIN acpyloadintosframe
data = tc.SFrame()
files = zip(sorted(acc_files), sorted(gyro_files))
# END acpyloadintosframe
# BEGIN acpyforeach
for acc_file, gyro_file in files:
    exp_id = int(acc_file.split('_')[1][-2:])
    user_id = int(acc_file.split('_')[2][4:6])
    
    # Load accel data
    sf = tc.SFrame.read_csv(acc_file, delimiter=' ', header=False, verbose=False)
    sf = sf.rename({'X1': 'acc_x', 'X2': 'acc_y', 'X3': 'acc_z'})
    sf['exp_id'] = exp_id
    sf['user_id'] = user_id
    
    # Load gyro data
    gyro_sf = tc.SFrame.read_csv(gyro_file, delimiter=' ', header=False, verbose=False)
    gyro_sf = gyro_sf.rename({'X1': 'gyro_x', 'X2': 'gyro_y', 'X3': 'gyro_z'})
    sf = sf.add_columns(gyro_sf)
    
    # Calc labels
    exp_labels = labels[labels['exp_id'] == exp_id][['activity_id', 'start', 'end']].to_numpy()
    sf = sf.add_row_number()
    sf['activity_id'] = sf['id'].apply(lambda x: find_label_for_containing_interval(exp_labels, x))
    sf = sf.remove_columns(['id'])
    
    data = data.append(sf)
# END acpyforeach
# BEGIN acpyencodereadable
target_map = {
    1.: 'walking',          
    2.: 'upstairs',
    3.: 'downstairs',
    4.: 'sitting',
    5.: 'standing',
    6.: 'resting'
}
# END acpyencodereadable

# FROM THE DATA:
# 1 WALKING           
# 2 WALKING_UPSTAIRS  
# 3 WALKING_DOWNSTAIRS
# 4 SITTING           
# 5 STANDING          
# 6 LAYING            
# 7 STAND_TO_SIT      
# 8 SIT_TO_STAND      
# 9 SIT_TO_LIE        
# 10 LIE_TO_SIT        
# 11 STAND_TO_LIE      
# 12 LIE_TO_STAND      

# Use the same labels used in the experiment
# BEGIN acpysavesframe
data = data.filter_by(target_map.keys(), 'activity_id')
data['activity'] = data['activity_id'].apply(lambda x: target_map[x])
data = data.remove_column('activity_id')

data.save('hapt_data.sframe')
# END acpysavesframe

# Train/test split by recording sessions
# BEGIN acpytraintest
train, test = tc.activity_classifier.util.random_split_by_session(data, session_id='exp_id', fraction=0.8)
# END acpytraintest

# Create an activity classifier
# BEGIN acpymakemodel
model = tc.activity_classifier.create(train, session_id='exp_id', target='activity', prediction_window=50)
# END acpymakemodel

# Evaluate the model and save the results into a dictionary
# BEGIN acpyeval
metrics = model.evaluate(test)
print(metrics['accuracy'])
# END acpyeval

# Save the model for later use in Turi Create
# BEGIN acpysavemodeltc
model.save('ActivityClassifier.model')
# END acpysavemodeltc

# Export for use in Core ML
# BEGIN acpyexportcoreml
model.export_coreml('ActivityClassifier.mlmodel')
# END acpyexportcoreml

# loaded_sframe = tc.load_sframe(`hapt_data.sframe`)
# loaded_model = tc.load_model('ActivityClassifier.model')
# BEGIN acpyaskingforprediction
walking_3_sec = loaded_sframe[(loaded_sframe['activity'] == 'walking') & (loaded_sframe['exp_id'] == 1)][1000:1150]
print(loaded_model.predict(walking_3_sec, output_frequency='per_window'))
# END acpyaskingforprediction
