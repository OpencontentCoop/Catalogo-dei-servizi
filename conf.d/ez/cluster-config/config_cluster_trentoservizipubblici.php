<?php

define( 'CLUSTER_STORAGE_GATEWAY_PATH',  'extension/ezpostgresqlcluster/clustering/dfs/gateway.php' );
define( 'CLUSTER_STORAGE_BACKEND',       'dfspostgresql'  );
define( 'CLUSTER_STORAGE_HOST',          'postgres' );
define( 'CLUSTER_STORAGE_PORT',          5432 );
define( 'CLUSTER_STORAGE_USER',          'openpa' );
define( 'CLUSTER_STORAGE_PASS',          'openp4ssword' );
define( 'CLUSTER_STORAGE_DB',            'trentoservizipubblici' );
define( 'CLUSTER_STORAGE_CHARSET',       'utf8' );
define( 'CLUSTER_MOUNT_POINT_PATH',      '/mnt/efs/cluster-comunweb/' );
define( 'CLUSTER_METADATA_TABLE_CACHE',  'ezdfsfile_cache' );
define( 'CLUSTER_METADATA_CACHE_PATH',   '/cache/' );
define( 'CLUSTER_METADATA_STORAGE_PATH', '/storage/' );
define( 'CLUSTER_EXPIRY_TIMEOUT',        2592000 );
