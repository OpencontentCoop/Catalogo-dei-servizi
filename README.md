# Catalogo dei servizi 

Sito Istituzionale del catalogo dei servizi pubblici del Comune di Trento, conforme alle linee guida di [Design Italia](https://designers.italia.it/progetti/siti-web-comuni/).

## Descrizione

Il sito è un'istanza di [OpenCity](https://www.opencontent.it/Per-la-PA/OpenCity), il modello di portale web avanzato, adatto a promuovere i contenuti di un ente pubblico in modalità multi-canale (pc, tablet,
smartphone, totem). Conforme alle Linee Guida di design per i servizi web della PA e sviluppato utilizzando i KIT di Designers
Italia, il sistema guida i redattori a creare e pubblicare contenuti strutturati, che vengono inseriti una sola volta nel sistema e
possono essere rappresentati automaticamente in gallerie fotografiche, calendari, mappe, grafici interattivi, aree riservate. In base
ai permessi, il contenuto diventa disponibile agli utenti anche attraverso un motore di ricerca unico, dotato di filtri progressivi e di
suggerimenti automatici. Strumento ideale per le redazioni distribuite: ciascun redattore detiene permessi e ruoli in base alla
competenza.

## Altri riferimenti

Per maggiori informazioni è possibile consultare: 

 * [Catalogo online dei servizi pubblici del Comune di Trento](http://servizi.comune.trento.it/)
 * [Demo di OpenCity](https://opencity.openpa.opencontent.io)
 * [Manuale utente](https://manuale-opencity-bootstrap-italia.readthedocs.io/it/latest/index.html)

## API 

 * [API della Demo](https://opencity.openpa.opencontent.io/api/opendata/)
 * [Documentazione API](https://documenter.getpostman.com/view/7046499/S17tPncG)


## Project Status

Il prodotto è *stabile* e *production ready* e usato in produzione nel Comune di Trento. Lo sviluppo avviene in modo costante, sia su richiesta degli Enti utilizzatori, sia su iniziativa autonoma del _maintainer_.

## Informazioni tecniche

L'applicazione è sviluppata sul CMS Ez Publish e consta di codice PHP, 
il dump del database contenente una installazione pienamente funzionante
dell'applicativo e i file di configurazione necessari per il motore di 
ricerca.

### Struttura del Repository

Il repository contiene i seguenti file:
```
composer.json
composer.lock
```
Il repository non contiene direttamente il codice applicativo, contiene 
invece il file delle dipendenze PHP (`composer.json`) che elenca tutti i componenti 
necessari all'applicazione: il CMS Ez Publish, le estensioni dello stesso 
utilizzate e tra queste l'estensione opencity che implementa le funzionalità 
più rilevanti. Con un comando `composer install` dalla stessa directory è possibile ottenere il codice dell'applicativo pronto all'uso (si veda anche [Dockerfile, L3](https://gitlab.com/opencontent/opencity/blob/master/Dockerfile#L3))

Le directory
```
/dfs/var/trentoservizipubblici
```
contengono invece le risorse statiche minime necessarie all'applicazione (loghi, elementi grafici generali, etc...).


```
/sql
```
La directory SQL contiene un dump del database PostgreSQL configurato e pronto all'uso.

Il file `Dockerfile` e le directory
```
/scripts
/conf.d
```
contengono file di supporto per la creazione dell'immagine Docker dell'applicativo.

Il file
```
docker-compose.yml
```
contiene i servizi minimi necessari per l'esecuzione del software e può essere usato per il deploy su un singolo host o su un cluster Docker Swarm o Kubernetes.

Il file
```
docker-compose.override.yml
```
viene usato automaticamente da docker-compose quando è disponibile: quando si clona il repository ad esempio e si hanno tutti i file a disposizione, questo aggiunge alcuni servizi di supporto utili in ambiente di sviluppo, come una interfaccia web per il database.


### Requisiti

Lo stack minimo del software è il seguente:
  * database PostgreSQL 9.6
  * PHP 7.2
  * Solr 4.10.x per il motore di ricerca

Nel file `docker-compose.yml` vengono inoltre utilizzati:
  * Varnish per la cache dei contenuti
  * Traefik per il routing tra i diversi container


### Come si esegue la build del repository

Con il comando che segue:

    docker build  .

si esegue la build dell'immagine docker dell'applicazione: vengono installate le dipendenze
del sistema operativo e successivamente composer e le dipendenze applicative.

### Local docker environment

Per avere un ambiente completo di demo o di sviluppo clonare
il repository e dalla directory principale dare i comandi:

```
sudo chown 8983 conf.d/solr/trentoservizipubblici/* -R
docker-compose up -d
docker-compose exec php bash -c 'cd html; php bin/php/updatesearchindex.php -s trentoservizipubblici_backend --allow-root-user'
```

Il catalogo dei servizi sarà disponibile ai seguenti indirizzi:

* [servizipubblici.localtest.me](https://opencity.localtest.me)
* [servizipubblici.localtest.me/backend](https://opencity.localtest.me/backend), per l'area riservata ai redattori e amministratori (l'utente di default con cui si accede è `admin/servizipubblici`)
* [solr.localtest.me/solr](https://solr.localtest.me/solr), per l'interfaccia amministrativa di SOLR
* [traefik.localtest.me:8080](https://traefik.localtest.me:8080) per l'interfaccia amministrativa di Traefik
* [Mailhog](https://mailhog.opencity.localtest.me/), le email inviate in questo ambiente sono visibili in questa interfaccia web
* [PgWeb](https://pgweb.opencity.localtest.me/), interfaccia web per il database PostgreSQL

Il certificato usato per tutti i domini è un wildcard self-signed certificate sul dominio *.localtest.me, quindi al primo collegamento si ottiene un warning.

### Useful commands

Per vedere i log di tutti container:

    docker-compose logs -f --tail 20

o solo uno di essi (ad esempio php):

    docker-compose logs -f --tail 20 php

Per ottenere una shell all'interno del container PHP, eseguire:

    docker-compose exec php bash

Per accedere al database da CLI:

    docker-compose exec postgres bash
    bash-4.4# psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"

Per aggiornare il dump del database nella cartella `sql`:

    docker-compose exec postgres bash
    bash-4.4# pg_dump -U ${POSTGRES_USER} $POSTGRES_DB | gzip > /docker-entrypoint-initdb.d/${POSTGRES_DB}.sql.gz

Per reindicizzare tutti i contenuti su SOLR:

    docker-compose exec php bash -c 'cd html; php bin/php/updatesearchindex.php -s trentoservizipubblici_backend --allow-root-user'


### Deploy in produzione

Per il deploy in un ambiente di produzione è necessario configurare diversi elementi: in generale
tutte le configurazioni si trovano nei file `conf.d/override/<file>.ini.append.php`, si indicano comunque
di seguito alcuni punti di sicuro interesse. 

## Copyright (C)

Il software è rilasciato con licenza aperta ai sensi dell'art. 69 comma 1 del [Codice dell’Amministrazione Digitale](https://cad.readthedocs.io/)

### Maintainer

[Opencontent SCARL](https://www.opencontent.it/), è responsabile della progettazione, realizzazione e manutenzione tecnica
