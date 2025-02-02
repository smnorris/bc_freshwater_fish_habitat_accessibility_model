============================
Data Distribution
============================

--------------------------------------------------------------------------
Freshwater Fish Habitat Accessibility MODEL - Pacific Salmon and Steelhead
--------------------------------------------------------------------------
A weekly bcfishpass data extract of Pacific Salmon (Chinook, Chum, Coho, Pink, Sockeye) and Steelhead access models (and associated data) is available for download as a zipped geopackage:

`https://nrs.objectstore.gov.bc.ca/bchamp/freshwater_fish_habitat_accessibility_MODEL.gpkg.zip <https://nrs.objectstore.gov.bc.ca/bchamp/freshwater_fish_habitat_accessibility_MODEL.gpkg.zip>`_.

The models included in this distribution are generated as described in the :ref:`model description section <description>`, with the following parameters:

- for salmon, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 15%
- for steelhead, potential :ref:`gradient barriers <gradient_barriers>` are considered passable up to 20%
- for both salmon and steelhead, potential natural barriers with 5 or more upstream observations of any of the target species (``CH, CM, CO, PK, SK, ST``) since January 01, 1990 are presumed to be passable

Tables/layers included in the distribution are:


barriers_salmon
============================

Locations of natural barriers to salmon (Chinook, Chum, Coho, Pink, Sockeye) migration
with no other natural barriers downstream, and less than 5 observations of salmon
or steelhead upstream since January 01, 1990.

Includes waterfalls, subsurface flow, gradient barriers of 15% and greater, and
misc user supplied barriers.

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/barriers_salmon.csv
   :header-rows: 1


barriers_steelhead
============================

Locations of natural barriers to steelhead migration with no other natural barriers
downstream, and less than 5 observations of salmon or steelhead upstream since January
01, 1990. Includes waterfalls, subsurface flow, gradient barriers of 20% and greater,
and user supplied misc barriers.

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/barriers_steelhead.csv
   :header-rows: 1


crossings
============================

Aggregated stream crossing locations.  Features are aggregated from:

- PSCIS stream crossings (where possible to match to an FWA stream)
- CABD dams (where possible to match to an FWA stream)
- modelled road/rail/trail stream crossings
- misc anthropogenic barriers from expert/local input

Includes barrier status, key attributes from source datasets, and various length upstream summaries.

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/crossings.csv
   :header-rows: 1


model_access
============================

FWA streams and access model output for watersheds with documented salmon or steelhead
presence. Access model output columns ``model_access_salmon`` and ``model_access_steelhead``
indicate the modelled status of a given stream. Values are:

``OBSERVED`` - no known natural barriers downstream, known observation of target species
present upstream. In the absence of anthropogenic barriers, target species have been observed
to access this stream.

``INFERRED`` - no known natural barriers downstream, no known observation of target species
present upstream. In the absence of anthropogenic barriers, target species could potentially
access this stream (presuming all else is equal and adequate flow is present in the stream).

``NATURAL_BARRIER`` - natural barrier downstream, inaccessible to target speces.

``NULL`` - species is not documented as present in this watershed group.

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/model_access.csv
   :header-rows: 1


observations
============================

Locations (on the FWA stream network) of known salmon and steelhead observations
used to generate the modelling. Derived from `Known BC Fish Observations <https://catalogue.data.gov.bc.ca/dataset/known-bc-fish-observations-and-bc-fish-distributions>`_
by `bcfishobs <https://github.com/smnorris/bcfishobs>`_.

.. csv-table::
   :file: tables/freshwater_fish_habitat_accessibility_model/observations.csv
   :header-rows: 1
