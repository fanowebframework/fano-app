(*!------------------------------------------------------------
 * Fano Web Framework Skeleton Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-app
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-app/blob/master/LICENSE (GPL 3.0)
 *------------------------------------------------------------- *)

{-----------------------------------------------
  register application configuration
------------------------------------------------}
container.add(
    'config',
    TJsonFileConfigFactory.create(
        extractFileDir(getCurrentDir()) + '/app/config/config.json'
    )
);

//Uncomment this if you want to use INI file config instead
// container.add(
//     'config',
//     TIniFileConfigFactory.create(
//         extractFileDir(getCurrentDir()) + '/app/config/config.ini'
//     )
// );
