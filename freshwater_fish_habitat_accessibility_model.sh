# Copyright 2024 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#!/bin/bash
set -euxo pipefail

# Dump freshwater_fish_habitat_accessibility_MODEL to file
# https://bcfishpass.s3.us-west-2.amazonaws.com/freshwater_fish_habitat_accessibility_MODEL.gpkg.zip

# create view
psql $DATABASE_URL -f sql/freshwater_fish_habitat_accessibility_model.sql

# clear any existing dumps
rm -rf freshwater_fish_habitat_accessibility_MODEL.gpkg*

echo 'dumping crossings'
ogr2ogr \
    -f GPKG \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln crossings \
    -nlt PointZM \
    -sql "select * from bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw"


echo 'dumping barriers_salmon'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln barriers_salmon \
    -nlt PointZM \
    -sql "select 
			 barriers_ch_cm_co_pk_sk_id,
			 barrier_type,
			 barrier_name,
			 linear_feature_id,
			 blue_line_key,
			 watershed_key,
			 downstream_route_measure,
			 wscode_ltree as wscode,
			 localcode_ltree as localcode,
			 watershed_group_code,
			 total_network_km,
			 geom
  		  from bcfishpass.barriers_ch_cm_co_pk_sk"


echo 'dumping barriers_steelhead'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln barriers_steelhead \
    -nlt PointZM \
    -sql "select 
			 barriers_st_id,
			 barrier_type,
			 barrier_name,
			 linear_feature_id,
			 blue_line_key,
			 watershed_key,
			 downstream_route_measure,
			 wscode_ltree as wscode,
			 localcode_ltree as localcode,
			 watershed_group_code,
			 total_network_km,
			 geom
  		  from bcfishpass.barriers_st"

echo 'dumping salmon/steelhead access model'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln model_access \
    -nlt LineStringZM \
    -sql "select * from bcfishpass.freshwater_fish_habitat_accessibility_model_vw"


echo 'dumping observations'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln observations \
    -nlt PointZM \
    -sql "select  
     fish_observation_point_id,
     fish_obsrvtn_event_id,
     species_code,
     observation_date,
     activity_code,
     activity,
     life_stage_code,
     life_stage,
     acat_report_url,
     linear_feature_id,
     blue_line_key,
     downstream_route_measure,
     wscode_ltree as wscode,
     localcode_ltree as localcode,
     watershed_group_code,
     geom
     from bcfishpass.freshwater_fish_habitat_accessibility_model_observations_vw"   

echo 'dump to MODEL.gpkg complete'    


# compress and publish to s3
# note that 7zip is not included in the bcfishpass conda environment.yml file, use some other package manager to install
7z a freshwater_fish_habitat_accessibility_MODEL.gpkg.zip freshwater_fish_habitat_accessibility_MODEL.gpkg
aws s3 cp freshwater_fish_habitat_accessibility_MODEL.gpkg.zip s3://bcfishpass/
aws s3api put-object-acl --bucket bcfishpass --key freshwater_fish_habitat_accessibility_MODEL.gpkg.zip --acl public-read

# delete unzipped
rm freshwater_fish_habitat_accessibility_MODEL.gpkg