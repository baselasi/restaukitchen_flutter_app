// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get commonAppTitle => 'Flutter Demo';

  @override
  String get commonHome => 'Home';

  @override
  String get commonMenus => 'Menu';

  @override
  String get commonOrders => 'Ordini';

  @override
  String get commonTables => 'Tavoli';

  @override
  String get commonCombinations => 'Combinazioni';

  @override
  String get commonSettings => 'Impostazioni';

  @override
  String get commonCategories => 'Categorie';

  @override
  String get commonIngredients => 'Ingredienti';

  @override
  String get commonDimensions => 'Dimensioni';

  @override
  String get commonSave => 'Salva';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonClose => 'Chiudi';

  @override
  String get commonContinue => 'Continua';

  @override
  String get commonRetry => 'Riprova';

  @override
  String get commonAdd => 'Aggiungi';

  @override
  String get commonAddDish => 'Aggiungi piatto';

  @override
  String get commonAddDishes => 'Aggiungi piatti';

  @override
  String get commonAddIngredients => 'Aggiungi ingredienti';

  @override
  String get commonEdit => 'Modifica';

  @override
  String get commonDelete => 'Elimina';

  @override
  String get commonRemove => 'Rimuovi';

  @override
  String get commonCreate => 'Crea';

  @override
  String get commonUpdate => 'Aggiorna';

  @override
  String get commonConfirm => 'Conferma';

  @override
  String get commonDone => 'Fatto';

  @override
  String get commonArchive => 'Archivia';

  @override
  String get commonPrint => 'Stampa';

  @override
  String get commonLoading => 'Caricamento...';

  @override
  String get commonLoadingEllipsis => '...';

  @override
  String get commonRequiredField => 'Questo campo è obbligatorio';

  @override
  String get commonValidNumber => 'Inserisci un numero valido';

  @override
  String get commonError => 'Errore';

  @override
  String get commonErrorOccurred => 'Si è verificato un errore';

  @override
  String get commonAreYouSure => 'Sei sicuro?';

  @override
  String get commonDescription => 'Descrizione';

  @override
  String get commonAddDescription => 'Aggiungi una descrizione';

  @override
  String get commonNote => 'Nota';

  @override
  String get commonNotAvailable => 'N/D';

  @override
  String get commonNoPriceSet => 'Nessun prezzo impostato';

  @override
  String get commonSelectDimension => 'Seleziona dimensione';

  @override
  String get commonNoDimensionsAvailable => 'Nessuna dimensione disponibile';

  @override
  String get commonSelectCategory => 'Seleziona categoria';

  @override
  String get commonGenerateQrCode => 'Genera codice QR';

  @override
  String get commonFailedLoadQrCode => 'Impossibile caricare il codice QR';

  @override
  String get commonFailedLoadCombination =>
      'Impossibile caricare la combinazione';

  @override
  String get commonNoCombinationDataFound =>
      'Nessun dato della combinazione trovato';

  @override
  String get commonFailedLoadDish => 'Impossibile caricare il piatto';

  @override
  String get commonFailedLoadIngredients =>
      'Impossibile caricare gli ingredienti';

  @override
  String get commonFailedLoadDimensions => 'Impossibile caricare le dimensioni';

  @override
  String get commonChangeImage => 'Cambia immagine';

  @override
  String get commonNewOrder => 'Nuovo ordine';

  @override
  String get commonCreateOrder => 'Crea ordine';

  @override
  String get commonSaveOrder => 'Salva ordine';

  @override
  String get commonNoDishesAvailable => 'Nessun piatto disponibile';

  @override
  String get commonNoMenus => 'Nessun menu';

  @override
  String get commonAvailable => 'Disponibile';

  @override
  String get commonUnavailable => 'Non disponibile';

  @override
  String get commonFree => 'Libero';

  @override
  String get commonReserved => 'Riservato';

  @override
  String get commonOccupied => 'Occupato';

  @override
  String get commonReceived => 'Ricevuto';

  @override
  String get commonOnFire => 'In preparazione';

  @override
  String get commonDoneStatus => 'Pronto';

  @override
  String get commonEnglish => 'Inglese';

  @override
  String get commonItalian => 'Italiano';

  @override
  String get commonFrench => 'Francese';

  @override
  String get commonSpanish => 'Spagnolo';

  @override
  String get commonArabic => 'Arabo';

  @override
  String get commonMonthJan => 'Gen';

  @override
  String get commonMonthFeb => 'Feb';

  @override
  String get commonMonthMar => 'Mar';

  @override
  String get commonMonthApr => 'Apr';

  @override
  String get commonMonthMay => 'Mag';

  @override
  String get commonMonthJun => 'Giu';

  @override
  String get commonMonthJul => 'Lug';

  @override
  String get commonMonthAug => 'Ago';

  @override
  String get commonMonthSep => 'Set';

  @override
  String get commonMonthOct => 'Ott';

  @override
  String get commonMonthNov => 'Nov';

  @override
  String get commonMonthDec => 'Dic';

  @override
  String get commonCurrencyDollar => '\$';

  @override
  String get commonCurrencyEuro => '€';

  @override
  String get commonEmDash => '—';

  @override
  String get commonHyphen => '-';

  @override
  String get commonCurrencyLebanesePound => 'L.L.';

  @override
  String commonPriceLabel(String price) {
    return 'Prezzo: $price';
  }

  @override
  String commonTableLabel(String number) {
    return 'Tavolo $number';
  }

  @override
  String commonCourseLabel(int number) {
    return 'Portata $number';
  }

  @override
  String commonQuantityLeading(int quantity) {
    return 'x$quantity';
  }

  @override
  String commonQuantityTrailing(int quantity) {
    return '${quantity}x';
  }

  @override
  String commonNoteWithValue(String note) {
    return 'Nota: $note';
  }

  @override
  String get authValidEmailAddress => 'Inserisci un indirizzo email valido';

  @override
  String get authLoginSuccessful => 'Accesso effettuato con successo!';

  @override
  String get authBadCredentials => 'Credenziali non valide';

  @override
  String get authWelcomeBack => 'Bentornato';

  @override
  String get authSignInContinue => 'Accedi per continuare';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'Inserisci la tua email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Inserisci la tua password';

  @override
  String get authLogin => 'Accedi';

  @override
  String get authForgotPassword => 'Password dimenticata?';

  @override
  String get authDemoEmail => 'ziadkhaled_822@hotmail.com';

  @override
  String get authDemoPassword => 'ziad';

  @override
  String get homeTableAvailability => 'Disponibilità tavoli';

  @override
  String get homeOpen => 'Aperti';

  @override
  String homeTotalTables(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tavoli totali',
      one: '1 tavolo totale',
      zero: '0 tavoli totali',
    );
    return '$_temp0';
  }

  @override
  String homeOpenOrders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ordini aperti',
      one: '1 ordine aperto',
      zero: '0 ordini aperti',
    );
    return '$_temp0';
  }

  @override
  String get settingsLogout => 'Esci';

  @override
  String get settingsCatalogue => 'CATALOGO';

  @override
  String get settingsMenusSubtitle => 'Configura i diversi menu stagionali';

  @override
  String get settingsCategoriesSubtitle =>
      'Organizza i piatti nelle sezioni del menu';

  @override
  String get settingsIngredientsSubtitle =>
      'Allergeni, disponibilità e dati fornitore';

  @override
  String get settingsDimensionsSubtitle => 'Porzioni e unità di misura';

  @override
  String get settingsErrorLoadingRestaurantInfo =>
      'Errore nel caricamento delle informazioni del ristorante';

  @override
  String get restaurantEditTitle => 'Modifica ristorante';

  @override
  String get restaurantNameLabel => 'Nome ristorante';

  @override
  String get restaurantNameHint => 'Inserisci il nome del ristorante';

  @override
  String get restaurantCountryLabel => 'Paese';

  @override
  String get restaurantLoadingCountries => 'Caricamento paesi...';

  @override
  String get restaurantSelectCountry => 'Seleziona un paese';

  @override
  String get restaurantSelectCountryRequired => 'Seleziona un paese';

  @override
  String get restaurantCityLabel => 'Citta';

  @override
  String get restaurantSearchCity => 'Cerca citta';

  @override
  String get restaurantSelectCountryFirstHint => 'Seleziona prima un paese';

  @override
  String get restaurantSelectCountryFirstError => 'Seleziona prima un paese';

  @override
  String get restaurantSelectCityRequired => 'Seleziona una citta';

  @override
  String get restaurantChooseCityFromList => 'Scegli una citta dall\'elenco';

  @override
  String get restaurantFailedLoadCountries => 'Impossibile caricare i paesi';

  @override
  String get restaurantFailedLoadCities => 'Impossibile caricare le citta';

  @override
  String get restaurantNoCitiesFound => 'Nessuna citta trovata';

  @override
  String get restaurantCurrencyLabel => 'Valuta';

  @override
  String get restaurantSelectCurrency => 'Seleziona una valuta';

  @override
  String get restaurantAddressLabel => 'Indirizzo';

  @override
  String get restaurantAddressHint => 'Inserisci l\'indirizzo';

  @override
  String get restaurantDescriptionHint => 'Inserisci la descrizione';

  @override
  String get restaurantErrorUpdating =>
      'Errore durante l\'aggiornamento del ristorante';

  @override
  String get tablesNewTable => 'Nuovo tavolo';

  @override
  String get tablesSortTables => 'Ordina tavoli';

  @override
  String get tablesNoTables => 'Nessun tavolo';

  @override
  String get tablesTotalCoversTitle => 'Coperti totali';

  @override
  String get tablesTotalCoversHint => 'Inserisci il numero totale di coperti';

  @override
  String get tablesTableNumberLabel => 'Numero tavolo';

  @override
  String get tablesTableSeatsLabel => 'Numero di posti del tavolo';

  @override
  String get tablesTableNumberInputLabel => 'Numero tavolo';

  @override
  String get tablesStatusLabel => 'Stato';

  @override
  String get tablesErrorLoadingTable => 'Errore nel caricamento del tavolo';

  @override
  String get tablesQrPreviewPlaceholder => 'Anteprima QR';

  @override
  String tablesSeatsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count posti',
      one: '$count posto',
    );
    return '$_temp0';
  }

  @override
  String get menusListTitle => 'Lista menu';

  @override
  String get menusUpdatedRecently => 'Aggiornato di recente';

  @override
  String get menusEditTooltip => 'Modifica menu';

  @override
  String get menusDeleteTooltip => 'Elimina menu';

  @override
  String get menusFailedDelete => 'Impossibile eliminare il menu';

  @override
  String get menusEditTitle => 'Modifica menu';

  @override
  String get menusCreateTitle => 'Crea menu';

  @override
  String get menusEditDescription => 'Modifica il nome del tuo menu.';

  @override
  String get menusCreateDescription =>
      'Aggiungi un nome per il tuo nuovo menu.';

  @override
  String get menusNameLabel => 'Nome menu';

  @override
  String get menusFailedCreate => 'Impossibile creare il menu';

  @override
  String menusItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi',
      one: '1 elemento',
      zero: '0 elementi',
    );
    return '$_temp0';
  }

  @override
  String get menusCombinationMenuBadge => 'Menu combinazione';

  @override
  String get dishesDeleteTitle => 'Elimina piatto';

  @override
  String dishesDeleteConfirmation(String dishName) {
    return 'Sei sicuro di voler eliminare \"$dishName\"? Questa azione non puo essere annullata.';
  }

  @override
  String get dishesDeletedSuccessfully => 'Piatto eliminato con successo';

  @override
  String get dishesFailedDelete => 'Impossibile eliminare il piatto';

  @override
  String get dishesCreatedSuccessfully => 'Piatto creato con successo';

  @override
  String get dishesNewDish => 'Nuovo piatto';

  @override
  String get dishesEssentials => 'Essenziali';

  @override
  String get dishesNameLabel => 'Nome';

  @override
  String get dishesAvailability => 'Disponibilita';

  @override
  String get dishesDimensionPricing => 'Dimensioni e prezzi';

  @override
  String get categoriesListTitle => 'Lista categorie';

  @override
  String get categoriesFailedLoad => 'Impossibile caricare le categorie';

  @override
  String get categoriesEditTooltip => 'Modifica categoria';

  @override
  String get categoriesDeleteTooltip => 'Elimina categoria';

  @override
  String get categoriesFailedDelete => 'Impossibile eliminare la categoria';

  @override
  String get categoriesEditTitle => 'Modifica categoria';

  @override
  String get categoriesCreateTitle => 'Crea categoria';

  @override
  String get categoriesEditDescription =>
      'Modifica il nome della tua categoria.';

  @override
  String get categoriesCreateDescription =>
      'Aggiungi un nome per la tua nuova categoria.';

  @override
  String get categoriesNameLabel => 'Nome categoria';

  @override
  String get categoriesUpdateTitle => 'Aggiorna categoria';

  @override
  String get categoriesFailedCreate => 'Impossibile creare la categoria';

  @override
  String get ingredientsListTitle => 'Lista ingredienti';

  @override
  String get ingredientsErrorLoading =>
      'Errore nel caricamento degli ingredienti';

  @override
  String get ingredientsEditTooltip => 'Modifica ingrediente';

  @override
  String get ingredientsDeleteTooltip => 'Elimina ingrediente';

  @override
  String get ingredientsErrorDeleting =>
      'Errore durante l\'eliminazione dell\'ingrediente';

  @override
  String get ingredientsCreateTitle => 'Crea ingrediente';

  @override
  String get ingredientsNameLabel => 'Nome';

  @override
  String get ingredientsErrorLoadingDimensions =>
      'Errore nel caricamento delle dimensioni';

  @override
  String get ingredientsNoIngredientsAvailable =>
      'Nessun ingrediente disponibile';

  @override
  String get ingredientsFailedAdd => 'Impossibile aggiungere gli ingredienti';

  @override
  String get ingredientsSelectedTitle => 'Ingredienti selezionati';

  @override
  String get dimensionsListTitle => 'Lista dimensioni';

  @override
  String get dimensionsStandard => 'Dimensione standard';

  @override
  String get dimensionsCustom => 'Dimensione personalizzata';

  @override
  String get dimensionsEditTooltip => 'Modifica dimensione';

  @override
  String get dimensionsDeleteTooltip => 'Elimina dimensione';

  @override
  String get dimensionsErrorDeleting =>
      'Errore durante l\'eliminazione della dimensione';

  @override
  String get dimensionsEditTitle => 'Modifica dimensione';

  @override
  String get dimensionsCreateTitle => 'Crea dimensione';

  @override
  String get dimensionsEditDescription =>
      'Modifica il nome e le impostazioni della tua dimensione.';

  @override
  String get dimensionsCreateDescription =>
      'Aggiungi un nome per la tua nuova dimensione.';

  @override
  String get dimensionsNameLabel => 'Nome dimensione';

  @override
  String get dimensionsSaveTitle => 'Salva dimensione';

  @override
  String get dimensionsAddTitle => 'Aggiungi dimensione';

  @override
  String get dimensionsCombinationNameLabel => 'Nome combinazione';

  @override
  String get dimensionsCombinationNameHint =>
      'Inserisci un nome per questa combinazione';

  @override
  String get dimensionsNext => 'Avanti';

  @override
  String get dimensionsPriceHint => '0.00';

  @override
  String get combinationsNoCombinations => 'Nessuna combinazione';

  @override
  String get combinationsEditPreviewTitle => 'Modifica combo';

  @override
  String get combinationsAddMenuTitle => 'Aggiungi menu';

  @override
  String get combinationsGroupNameLabel => 'Nome gruppo';

  @override
  String get combinationsErrorCreatingGroup =>
      'Errore durante la creazione del gruppo';

  @override
  String get combinationsNoDishesInMenu => 'Nessun piatto in questo menu';

  @override
  String get combinationsNoPlatesForSelectedDimension =>
      'Nessun piatto disponibile per la dimensione selezionata';

  @override
  String get combinationsDeletedSuccessfully =>
      'Combinazione eliminata con successo';

  @override
  String get combinationsErrorDeleting =>
      'Errore durante l\'eliminazione della combinazione';

  @override
  String get orderFormSelectDimension => 'Seleziona la dimensione';

  @override
  String get orderFormAddNoteForDish => 'Aggiungi una nota per questo piatto';

  @override
  String get orderFormAddNoteForOrder => 'Aggiungi una nota per questo ordine';

  @override
  String get orderFormPleaseChooseDimension => 'Seleziona una dimensione';

  @override
  String get orderFormNoDishesInCourse => 'Nessun piatto in questa portata';

  @override
  String get orderFormCreateNewCourse => 'CREA NUOVA PORTATA';

  @override
  String get ordersKitchen => 'Cucina';

  @override
  String get ordersArchive => 'Archivio';

  @override
  String get ordersDeleted => 'Eliminati';

  @override
  String get ordersNoOrdersYet => 'Nessun ordine';

  @override
  String get ordersNoArchivedOrders => 'Nessun ordine archiviato';

  @override
  String get ordersNoDeletedOrders => 'Nessun ordine eliminato';

  @override
  String get ordersNoDishesInOrder => 'Nessun piatto in questo ordine.';

  @override
  String ordersTotalLabel(String amount) {
    return 'Totale: €$amount';
  }

  @override
  String ordersCombinationDishBullet(String name) {
    return '• $name';
  }
}
