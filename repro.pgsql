
set timezone='Europe/Budapest';
--set timezone=C;
CALL cagg_migrate('farm_tscondition_10m', override => TRUE, drop_old => TRUE);
