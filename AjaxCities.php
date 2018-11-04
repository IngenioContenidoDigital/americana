<?php
include_once('./config/defines.inc.php');
include_once('./config/config.inc.php');

$scities = "SELECT
"._DB_PREFIX_."cities.id_cities,
"._DB_PREFIX_."cities.ciudad
FROM
"._DB_PREFIX_."cities
INNER JOIN "._DB_PREFIX_."state ON "._DB_PREFIX_."state.codigo_departamento = "._DB_PREFIX_."cities.codigo_departamento
WHERE
"._DB_PREFIX_."state.id_state = ".Tools::getValue('state');
$cities = Db::getInstance()->executeS($scities);

echo json_encode($cities);