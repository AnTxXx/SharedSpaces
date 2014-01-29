<?php
/**
 * Schreibt die erhaltenen Positionsdaten (JSON) in die DB
 */
require 'api.php';

$api = new SpacesAPI;
$api->writeSkeletonsToDB();

?>