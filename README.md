### Studente: Marzio Della Bosca 
### Matricola: 329608

# T Tracker

## In sintesi:
T Tracker è un applicazione compatibile su piattaforma windows e web. Lo scopo è quello di dare all'utente una serie di strumenti utili
a tenere traccia delle diverse attività e/o impegni di suo interesse.

## Casi d'uso:
Per tenere traccia delle attività di suo interesse l'utente può creare, eliminare e modificare delle attività. Quando l'utente vuole creare un attività deve definire diverse campi:

- Titolo: il titolo dell'attività;
- Durata: quanto tempo richiede tale attività per essere evasa (in ore);
- Tipo: rappresenta la categoria alla quale l'attivtà è associata, le categorie sono 4: lavoro, studio, sport e altro;
- Descrizione: una breve descrizione dell'attività, utile dato che si possono avere diverse attività dello stesso tipo.

Quando le attività sono state create l'utente potra consultare un calendario messo a disposizione su un altra pagina dell'applicazione, in modo da tenere traccia gli impegni che si hanno nel tempo.

Un altra funzionalità messa a disposizione dell'utente è quella di avere informazione riguardo a quale categoria di attività è quella più di moda, avendo, in un altra schermata, un grafico a torta che mostra la quantità di ore spese per ogni categoria di attività.

L'utente ha inoltre la possibilità di modificare la visualizzazione della propria applicazione, potendo scegliere tra 6 immagini distinte. Infine, può modificare il proprio nome utente e la propria password, dato che l'applicazione è pensata per essere multiutente. Per sicurezza e privacy, i dati degli utenti vengono crittografati utilizzando una crittografia di tipo AES (Advanced Encryption Standard), in modo che la chiave di crittografia sia generata dalla password dell'utente. In questo modo, le password non sono presenti né in chiaro né nel codice, rendendo il sistema più sicuro.

## Esperienza utente:
All'avvio dell'applicazione, l'utente si troverà di fronte alla schermata di login, con due campi di testo per inserire rispettivamente nome utente e password. Dopo aver effettuato il login (o la registrazione, che permette l'accesso all'applicazione), la prima schermata visibile sarà quella di home. Sul lato sinistro dell'interfaccia sarà sempre presente la barra di navigazione, che assiste l'utente nella navigazione tra le varie schermate.

La schermata di home accoglie l'utente, lo saluta e fornisce diverse informazioni riguardanti l'orario e la posizione, come il nome della città in cui si trova, la temperatura e le condizioni meteorologiche.

La seconda schermata, accessibile tramite la seconda icona dall'alto verso il basso, mostra probabilmente la schermata più importante. Qui è possibile creare, modificare ed eliminare attività. A destra della barra di navigazione viene mostrata la lista delle attività dell'utente, mentre a destra è presente il modulo per la creazione e/o modifica dell'attività selezionata. Sotto il modulo per la creazione dell'attività, l'applicazione visualizza i dati dell'attività selezionata.

La terza schermata visualizza il grafico a torta delle attività, corredato da una breve legenda, suddivise per categoria.

Nella quarta schermata è presente il calendario, che si apre sul mese corrente ma consente all'utente di navigare tra i vari mesi. I giorni del mese in cui sono presenti attività vengono contrassegnati con una stellina. Cliccando su un giorno contrassegnato, compare sotto al calendario l'elenco delle attività presenti in quella giornata. Cliccando su un'attività, compare a destra dell'elenco una finestra contenente i dati di quella attività selezionata.

Nella quinta schermata è possibile modificare lo sfondo dell'applicazione, il nome utente e la password. Nella sesta schermata sono presenti diverse schede che forniscono indicazioni sul corretto utilizzo dell'applicazione.

Infine, vi è il pulsante di logout che salva i dati e riporta alla schermata di login. 

Ho deciso di implementare i testi in inglese in quanto la trovo una buona pratica didattica, in quanto non so ancora dove andrò a lavorare, ne per chi, inoltre il mio progetto è stato volutamente messo pubblico su GitHub in modo da dare un'idea per chi ha bisogno, e l'inglese è la lingua più comune.

## Tecnologia:
Per l'implementazione dell'applicazione sono state incluse diverse dipendenze:
- provider: necessaria per gestire l'utilizzo dei provider, per far comunicare le diverse pagine.
- table_calendar: utilizzata per avere uno scheletro nell'implementazione del calendario.
- intl: utilizzata principalmente per le conversioni di formato 'Date' in stringa e viceversa.
- fl_charts: utilizzato per implemetare il grafico delle attività.
- http: utilizzato per la gestione delle chiamate alle API per ottenere l'indirizzo IP e i dati meteorologici, come il tempo e la temperatura.
- timer_builder: utilizzato per la costruzione del widget orologio.
- encrypt: utilizzato per la criptazione e decriptazione dei dati degli utenti.
- window_manager: utilizzato per la gestione della finestra dell'applicazione.
- shared_preferences: utilizzato per la gestione dei dati nelle applicazioni web.

Inoltre in pubspec.yaml è stato definito l'assets, in modo da poter utilizzare le immagini di sfondo.

Le attività nel modello sono rappresentate come oggetti, i cui campi sono inseriti dagli utenti. Il sistema di input è progettato per ottenere dati "il più puliti possibile", il che significa che, quando possibile, si obbliga l'utente a scegliere tra varie opzioni (come ad esempio la definizione della data tramite un datePicker o la scelta della categoria attraverso un menu a discesa). Quando ciò non è possibile, sono state introdotte una serie di validazioni che impediscono all'utente di inserire dati che potrebbero causare problemi.

Per quanto riguarda l'implementazione delle strategie di crittografia utilizzando AES, ho scelto di includere anche l'uso di un vettore di inizializzazione generato in modo casuale. Questo vettore è utile nel caso in cui più utenti utilizzino la stessa password (che funge da chiave per la crittografia e la decrittografia dei dati), riducendo così la probabilità che una password possa essere utilizzata per decrittare i dati di più utenti. Le chiavi utilizzate sono inoltre lunghe 32 byte. Nel caso in cui l'utente inserisca una password più lunga, viene bloccata la registrazione e all'utente viene richiesto di scegliere una password diversa. Nel caso più comune in cui la password è più corta, viene applicata una strategia di padding per portare la chiave a 32 caratteri (codifica utf-8), aggiungendo dei '.' per raggiungere la lunghezza desiderata.

Per questioni di organizzazione, ogni pagina è definita da un singolo file .dart, che può comunque utilizzare widget definiti in altri file. Si è cercato di mantenere una corrispondenza uno a uno tra pagina e file. Nel modello, oltre al file che implementa la classe Attività, sono presenti un file .dart contenente tutti i provider, un file contenente tutte le utility definite come metodi statici richiamati quando necessario da tutti gli altri widget del progetto, e un file chiamato UserDataHandler. La creazione del file UserDataHandler è stata necessaria per mantenere il codice il più pulito possibile poiché la gestione dei dati nell'ambito di Windows è molto diversa dall'ambito web. Per evitare di appesantire troppo il codice negli altri file e nel file Utilities, è stata preferita l'implementazione di una nuova classe nel file UserDataHandler.

Per gestire i margini, ho implementato un widget che restituisce una riga o una colonna a seconda delle dimensioni della finestra. Inoltre, ho cercato di creare il maggior numero possibile di widget per mantenere i file di codice relativamente brevi e quindi facilmente leggibili durante la fase di debug.

Tranne per le pagine di login, statistiche e aiuto, le altre pagine sono tutte implementate come StatefulWidget. La decisione di renderizzare una pagina in Flutter come StatefulWidget o StatelessWidget dipende dal fatto che i dati mostrati nel widget possano cambiare nel tempo. Uno StatefulWidget mantiene lo stato che può variare nel corso del tempo, come ad esempio la pagina Home, dove ho implementato un orologio. La pagina HomePage è un StatefulWidget perché devo evidenziare l'ultima icona premuta per aiutare l'utente a orientarsi meglio nell'applicazione. Nella pagina di creazione delle attività, ho bisogno di uno StatefulWidget per gestire la creazione delle attività tramite l'input dell'utente, mostrarle in una lista e tracciare l'attività selezionata, che poi viene descritta tramite uno StatelessWidget sotto il form di input. Nella pagina del calendario, devo sempre visualizzare gli elementi della lista delle attività, che variano a seconda del giorno selezionato, e gestire la visualizzazione della descrizione dell'attività selezionata. Inoltre, il widget del calendario si modifica quando navigo tra i diversi mesi. Ho reso la pagina delle impostazioni StatefulWidget perché deve aggiornarsi quando cambio il tema dell'applicazione.


### Bibliografia
Ci tengo a includere tutti i siti in cui ho trovato risorse:

Per API acquisizione IP: <a href="https://app.ipgeolocation.io/"></a> 
Per API acquisizione condizioni meteo: <a href="https://openweathermap.org/api/one-call-3"></a> 

Per Immagini applicazioni:
- <a href="https://unsplash.com/it/@sandrokatalina?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Sandro Katalina</a> 
- <a href="https://unsplash.com/it/@vincentiu?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Vincentiu Solomon</a>
- <a href="https://unsplash.com/it/@beckerworks?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">David Becker</a> 
- <a href="https://unsplash.com/it/@mbzzgeorgia?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Michael Bourgault</a> 
- <a href="https://unsplash.com/it/@danesduet?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Daniel Olah</a> 
- <a href="https://unsplash.com/it/@cristina_gottardi?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Cristina Gottardi</a>
  












