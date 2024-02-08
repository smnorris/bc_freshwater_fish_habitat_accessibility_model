-- Copyright 2024 Province of British Columbia
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


-- for publication to DataBC Catalouge
-- freshwater_fish_habitat_accessibility_MODEL.gpkg.zip

-- all streams/combined salmon/steelhead product
drop view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_vw;
create view bcfishpass.freshwater_fish_habitat_accessibility_model_vw as
select
  s.segmented_stream_id,
  s.linear_feature_id,
  s.edge_type,
  s.blue_line_key,
  s.downstream_route_measure,
  s.upstream_route_measure,
  s.watershed_group_code,
  s.gnis_name,
  s.stream_order,
  s.stream_magnitude,
  s.gradient,
  s.wscode_ltree as wscode,
  s.localcode_ltree as localcode,
  s.feature_code,
  case
    when cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0 and a.obsrvtn_upstr_salmon is true then 'OBSERVED'
    when cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) = 0 and a.obsrvtn_upstr_salmon is false then 'INFERRED'
    when cardinality(a.barriers_ch_cm_co_pk_sk_dnstr) > 0 then 'NATURAL_BARRIER'
    else NULL
  end as model_access_salmon,
  case
    when cardinality(a.barriers_st_dnstr) = 0 and a.obsrvtn_upstr_st is true then 'OBSERVED'
    when cardinality(a.barriers_st_dnstr) = 0 and a.obsrvtn_upstr_st is false then 'INFERRED'
    when cardinality(a.barriers_st_dnstr) > 0 then 'NATURAL_BARRIER'
    else NULL
  end as model_access_steelhead,
  array_to_string(a.barriers_ch_cm_co_pk_sk_dnstr, ';') as barriers_ch_cm_co_pk_sk_dnstr,
  array_to_string(a.barriers_st_dnstr, ';') as barriers_st_dnstr,
  array_to_string(a.barriers_anthropogenic_dnstr, ';') as barriers_anthropogenic_dnstr,
  array_to_string(a.barriers_pscis_dnstr, ';') as barriers_pscis_dnstr,
  array_to_string(a.barriers_dams_dnstr, ';') as barriers_dams_dnstr,
  a.dam_dnstr_ind,
  a.dam_hydro_dnstr_ind,
  a.remediated_dnstr_ind,
  s.geom
from bcfishpass.streams s
left outer join bcfishpass.streams_access_vw a on s.segmented_stream_id = a.segmented_stream_id
left outer join bcfishpass.streams_habitat_linear_vw h on s.segmented_stream_id = h.segmented_stream_id;


-- no views required for barrier tables, they can be used directly (only change would be renaming wscode/localcode)

-- dump observations for salmon and steelhead used in this analysis
drop view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_observations_vw;
create view bcfishpass.freshwater_fish_habitat_accessibility_model_observations_vw as
select * from bcfishpass.observations_vw 
where species_code in ('CH','CM','CO','PK','SK','ST');


-- create view of crossings with just salmon/steelhead related columns
drop view if exists bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw;
create view bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw as
select
 c.aggregated_crossings_id,
 c.stream_crossing_id,
 c.dam_id,
 c.user_barrier_anthropogenic_id,
 c.modelled_crossing_id,
 c.crossing_source,
 c.crossing_feature_type,
 c.pscis_status,
 c.crossing_type_code,
 c.crossing_subtype_code,
 c.modelled_crossing_type_source,
 c.barrier_status,
 c.pscis_road_name,
 c.pscis_stream_name,
 c.pscis_assessment_comment,
 c.pscis_assessment_date,
 c.pscis_final_score,
 c.transport_line_structured_name_1,
 c.transport_line_type_description,
 c.transport_line_surface_description,
 c.ften_forest_file_id,
 c.ften_file_type_description,
 c.ften_client_number,
 c.ften_client_name,
 c.ften_life_cycle_status_code,
 c.rail_track_name,
 c.rail_owner_name,
 c.rail_operator_english_name,
 c.ogc_proponent,
 c.dam_name,
 c.dam_height,
 c.dam_owner,
 c.dam_use,
 c.dam_operating_status,
 c.utm_zone,
 c.utm_easting,
 c.utm_northing,
 c.dbm_mof_50k_grid,
 c.linear_feature_id,
 c.blue_line_key,
 c.watershed_key,
 c.downstream_route_measure,
 c.wscode,
 c.localcode,
 c.watershed_group_code,
 c.gnis_stream_name,
 c.stream_order,
 c.stream_magnitude,
 c.observedspp_dnstr,
 c.observedspp_upstr,
 c.crossings_dnstr,
 c.barriers_anthropogenic_dnstr,
 c.barriers_anthropogenic_dnstr_count,
 c.barriers_anthropogenic_upstr,
 c.barriers_anthropogenic_upstr_count,
 c.barriers_anthropogenic_ch_cm_co_pk_sk_upstr,
 c.barriers_anthropogenic_ch_cm_co_pk_sk_upstr_count,
 c.barriers_anthropogenic_st_upstr,
 c.barriers_anthropogenic_st_upstr_count,
 c.gradient,
 c.total_network_km,
 c.total_stream_km,
 c.total_lakereservoir_ha,
 c.total_wetland_ha,
 c.total_slopeclass03_waterbodies_km,
 c.total_slopeclass03_km,
 c.total_slopeclass05_km,
 c.total_slopeclass08_km,
 c.total_slopeclass15_km,
 c.total_slopeclass22_km,
 c.total_slopeclass30_km,
 c.total_belowupstrbarriers_network_km,
 c.total_belowupstrbarriers_stream_km,
 c.total_belowupstrbarriers_lakereservoir_ha,
 c.total_belowupstrbarriers_wetland_ha,
 c.total_belowupstrbarriers_slopeclass03_waterbodies_km,
 c.total_belowupstrbarriers_slopeclass03_km,
 c.total_belowupstrbarriers_slopeclass05_km,
 c.total_belowupstrbarriers_slopeclass08_km,
 c.total_belowupstrbarriers_slopeclass15_km,
 c.total_belowupstrbarriers_slopeclass22_km,
 c.total_belowupstrbarriers_slopeclass30_km,
 c.barriers_ch_cm_co_pk_sk_dnstr,
 c.ch_cm_co_pk_sk_network_km,
 c.ch_cm_co_pk_sk_stream_km,
 c.ch_cm_co_pk_sk_lakereservoir_ha,
 c.ch_cm_co_pk_sk_wetland_ha,
 c.ch_cm_co_pk_sk_slopeclass03_waterbodies_km,
 c.ch_cm_co_pk_sk_slopeclass03_km,
 c.ch_cm_co_pk_sk_slopeclass05_km,
 c.ch_cm_co_pk_sk_slopeclass08_km,
 c.ch_cm_co_pk_sk_slopeclass15_km,
 c.ch_cm_co_pk_sk_slopeclass22_km,
 c.ch_cm_co_pk_sk_slopeclass30_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_network_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_stream_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_lakereservoir_ha,
 c.ch_cm_co_pk_sk_belowupstrbarriers_wetland_ha,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass03_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass05_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass08_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass15_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass22_km,
 c.ch_cm_co_pk_sk_belowupstrbarriers_slopeclass30_km,
 c.barriers_st_dnstr,
 c.st_network_km,
 c.st_stream_km,
 c.st_lakereservoir_ha,
 c.st_wetland_ha,
 c.st_slopeclass03_waterbodies_km,
 c.st_slopeclass03_km,
 c.st_slopeclass05_km,
 c.st_slopeclass08_km,
 c.st_slopeclass15_km,
 c.st_slopeclass22_km,
 c.st_slopeclass30_km,
 c.st_belowupstrbarriers_network_km,
 c.st_belowupstrbarriers_stream_km,
 c.st_belowupstrbarriers_lakereservoir_ha,
 c.st_belowupstrbarriers_wetland_ha,
 c.st_belowupstrbarriers_slopeclass03_waterbodies_km,
 c.st_belowupstrbarriers_slopeclass03_km,
 c.st_belowupstrbarriers_slopeclass05_km,
 c.st_belowupstrbarriers_slopeclass08_km,
 c.st_belowupstrbarriers_slopeclass15_km,
 c.st_belowupstrbarriers_slopeclass22_km,
 c.st_belowupstrbarriers_slopeclass30_km,
 c.geom
 from bcfishpass.crossings_vw c;
