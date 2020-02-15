
# ggblur 0.1.2  2020-02-15

* Reworked how a sequence of individual overlapping alphas are created in order
  to achieve a more consistent blur appearance.
* Removed `blur_alpha` as a parameter. Alpha is now derived from that of the 
  parent point object. This does not currently support a different alpha per-point,
  but assumes that alpha is constant across all points.

# ggblur 0.1.1  2020-02-11

* Added legend support

# ggblur 0.1.0  2020-02-09

* Initial release
