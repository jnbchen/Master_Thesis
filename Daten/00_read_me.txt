Matlab version:
- Matlab 2016a

Required toolboxes: 
- Control System Toolbox
- Signal Processing Toolbox
- Robust Control Toolbox
- ScixMiner (available under https://sourceforge.net/projects/scixminer/)

Readme:
1. Every m-file corresponds to a subsection of the paper, run the file to get the results of the subsection:
   rand_model        -- 2.1 Road model
   fcm_space_v_time  -- 2.2 Basic full car model
   fcm_tf            -- 2.3 Transfer function of the full car model
   fcm_arb           -- 2.4 Full car model with anti-roll bar
   fcm_atv           -- 2.4 Full car model with active suspension
   fcm_op            -- 2.4 Position of outputs
   validation_dp     -- 3.1 Identification and validation of the damping ratio
   validation_rm     -- 3.2 Identification and validation of the tire model   feature_extr      -- 4.3 Feature extraction

2. The process of the classification have to be manually processed by ScixMiner, which is in the folder '01_gaitcad2014b_english'.

3. - The matrix of the features are saved in the folder '04_data_mining/feature_matrix';
   - The projects are saved in the folder '04_data_mining/project';
   - The trained classifier are saved in the folder '04_data_mining/classifier';
   - Some figures are saved in the folder '05_images';
   - Car models in Simulink and rigid ring model are saved in the folder '06_reference'.

4. Before data-mining with ScixMiner, update the path in gaitcad.m to your local names:
   gaitcadpath = 'your_local_names';

5. Using and Setting of the ScixMiner please refer to the 'User¡¯s Manual'.


Jinbo Chen
jinbo.b.chen@gmail.com
