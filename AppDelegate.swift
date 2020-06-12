//
//  AppDelegate.swift
//  Spelling Bee
//
//  Created by Lennart Philipp on 30.03.20.
//  Copyright © 2020 Lennart Philipp. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func createEnglishDemoGames() {
        
        let moc = persistentContainer.viewContext
        
        // Daily
        let dailyGame = SpellingBeeGame(context: moc)
        dailyGame.letters = ["R", "U", "N", "T", "C", "L", "I"]
        dailyGame.isDaily = true
        dailyGame.isNew = true
        dailyGame.language = "English"
        dailyGame.correctWords = ["Testwort"]
        dailyGame.guessedWords = []
        dailyGame.dateAdded = Date()
        dailyGame.lastPlayed = Date()
        
        
        let customGameThree = SpellingBeeGame(context: moc)
        customGameThree.language = "English"
        customGameThree.dateAdded = Date(timeIntervalSinceNow: 0)
        customGameThree.lastPlayed = Date()
        customGameThree.isDaily = false
        customGameThree.isNew = false
        customGameThree.maxTime = 86400
        customGameThree.correctWords = ["Testwort"]
        customGameThree.guessedWords = []
        customGameThree.letters = ["S", "E", "L", "T", "P", "I", "N"]
        
        
        let customGameTwo = SpellingBeeGame(context: moc)
        customGameTwo.letters = ["O", "N", "T", "R", "S", "C", "H"]
        customGameTwo.maxTime = 0
        customGameTwo.isDaily = false
        customGameTwo.isNew = false
        customGameTwo.language = "English"
        customGameTwo.dateAdded = Date(timeIntervalSinceNow: -3)
        customGameTwo.lastPlayed = Date()
        customGameTwo.correctWords = ["CHOCHO", "CHOCHOS", "CHOCO", "CHON", "CHOOCHOO", "CHORT", "CHOTT", "CHOTTS", "CHRON", "CHRONON", "CHRONONS", "CHRONOS", "COCCO", "COCH", "COCHON", "COCO", "COCOON", "COCOONS", "COCOROOT", "COCOS", "COCT", "COHO", "COHORN", "COHORT", "COHORTS", "COHOS", "COHOSH", "COHOST", "COHOSTS", "CONC", "CONCH", "CONCHO", "CONCHS", "CONCN", "CONCOCT", "CONCOCTOR", "CONCOCTS", "CONN", "CONNS", "CONOR", "CONS", "CONSORT", "CONSORTS", "CONST", "CONSTR", "CONT", "CONTO", "CONTORNO", "CONTORT", "CONTORTS", "CONTOS", "CONTR", "COOCH", "COON", "COONROOT", "COONS", "COOS", "COOST", "COOT", "COOTCH", "COOTH", "COOTS", "CORN", "CORNO", "CORNROOT", "CORNS", "CORR", "CORSO", "CORSOS", "CORT", "CORTON", "COSH", "COSS", "COST", "COSTS", "COTCH", "COTH", "COTHON", "COTO", "COTORO", "COTOROS", "COTS", "COTT", "COTTON", "COTTONS", "CROC", "CROH", "CROOCH", "CROON", "CROONS", "CROSS", "CROST", "CROTCH", "CROTON", "CROTONS", "HOCCO", "HOCH", "HOHN", "HOHO", "HONCHO", "HONCHOS", "HONOR", "HONORS", "HONT", "HOOCH", "HOON", "HOOROO", "HOOROOSH", "HOOSH", "HOOT", "HOOTCH", "HOOTS", "HORN", "HORNS", "HORROR", "HORRORS", "HORS", "HORST", "HORSTS", "HORT", "HOSS", "HOST", "HOSTS", "HOTCH", "HOTS", "HOTSHOT", "HOTSHOTS", "NOCHT", "NONCON", "NOON", "NOONS", "NORN", "NORTH", "NORTHS", "NOSH", "NOSTOC", "NOSTOCS", "NOTCH", "NOTS", "OCHRO", "OCHT", "OCONNOR", "OCTOON", "OCTOROON", "OCTOROONS", "ONCOST", "ONTO", "OOHS", "OONS", "OONT", "OOOO", "OOTS", "ORCH", "ORCS", "OROCHON", "ORONOCO", "ORSON", "ORTH", "ORTHO", "ORTHRON", "ORTHROS", "ORTS", "OTTO", "OTTOS", "RHOS", "ROCOCO", "ROCOCOS", "ROCS", "RONCHO", "RONCO", "RONCOS", "ROON", "ROOST", "ROOSTS", "ROOT", "ROOTS", "RORT", "ROSS", "ROTCH", "ROTO", "ROTOR", "ROTORS", "ROTOS", "ROTS", "SCHO", "SCHOON", "SCOOCH", "SCOON", "SCOOT", "SCOOTS", "SCORCH", "SCORCHS", "SCORN", "SCORNS", "SCOT", "SCOTCH", "SCOTS", "SCOTT", "SCROO", "SCROOCH", "SHOO", "SHOON", "SHOOR", "SHOOS", "SHOOT", "SHOOTS", "SHOR", "SHORN", "SHORT", "SHORTHORN", "SHORTHORNS", "SHORTS", "SHOT", "SHOTS", "SHOTT", "SHOTTS", "SNOOT", "SNOOTS", "SNORT", "SNORTS", "SNOT", "SNOTS", "SOCHT", "SOCO", "SOHO", "SONS", "SOON", "SOOSOO", "SOOT", "SOOTH", "SOOTHS", "SOOTS", "SORN", "SORNS", "SORT", "SORTS", "SOSH", "SOSO", "SOSS", "SOTH", "SOTHO", "SOTHS", "SOTS", "SSORT", "SSTOR", "STOON", "STOOT", "STOOTH", "STOR", "STOSH", "STOSS", "STOSSTON", "STOT", "STOTT", "STROOT", "STROTH", "THOCHT", "THON", "THOO", "THOR", "THORN", "THORNS", "THORO", "THORON", "THORONS", "THORT", "THOS", "THRO", "THRONOS", "TOCH", "TOCO", "TOCORORO", "TOHO", "TONN", "TONS", "TONSOR", "TONTO", "TOON", "TOONS", "TOOROO", "TOOSH", "TOOT", "TOOTH", "TOOTHS", "TOOTS", "TORC", "TORCH", "TORCHON", "TORCHONS", "TORCS", "TORN", "TORO", "TORONTO", "TOROS", "TOROTH", "TOROTORO", "TORR", "TORS", "TORSO", "TORSOS", "TORT", "TORTOR", "TORTS", "TOSH", "TOSS", "TOST", "TOSTON", "TOTO", "TOTORO", "TOTS", "TROCH", "TROCO", "TRON", "TRONC", "TROOT", "TROT", "TROTH", "TROTHS", "TROTS"]
        customGameTwo.guessedWords = ["SSORT", "SSTOR", "STOON", "STOOT", "STOOTH", "STOR", "STOSH", "STOSS", "STOSSTON", "STOT", "STOTT", "STROOT", "STROTH", "THOCHT", "THON", "THOO", "THOR", "THORN", "THORNS", "THORO", "THORON", "THORONS", "THORT", "THOS", "THRO", "THRONOS", "TOCH", "TOCO", "TOCORORO", "TOHO", "TONN", "TONS", "TONSOR", "TONTO", "TOON", "TOONS", "TOOROO", "TOOSH", "TOOT", "TOOTH", "TOOTHS", "TOOTS", "TORC", "TORCH", "TORCHON", "TORCHONS", "TORCS", "TORN", "TORO", "TORONTO", "TOROS", "TOROTH", "TOROTORO", "TORR", "TORS", "TORSO", "TORSOS", "TORT", "TORTOR", "TORTS", "TOSH", "TOSS", "TOST", "TOSTON", "TOTO", "TOTORO", "TOTS", "TROCH", "TROCO", "TRON", "TRONC", "TROOT", "TROT", "TROTH", "TROTHS", "TROTS"]
        
        let customGameOne = SpellingBeeGame(context: moc)
        customGameOne.letters = ["S", "H", "L", "E", "P", "I", "T"]
        customGameOne.maxTime = 0
        customGameOne.language = "English"
        customGameOne.isNew = false
        customGameOne.isDaily = false
        customGameOne.dateAdded = Date(timeIntervalSinceNow: -10)
        customGameOne.lastPlayed = Date()
        customGameOne.correctWords = ["EELIEST", "EELS", "EISELL", "ELITES", "ELITIST", "ELITISTS", "ELLIPSE", "ELLIPSES", "ELLIPSIS", "ELLS", "ELSE", "ELSES", "EPEEIST", "EPEEISTS", "EPEES", "EPHELIS", "EPILEPSIES", "EPIST", "EPISTLE", "EPISTLES", "EPITHESIS", "EPITHETS", "EPPES", "ESES", "ESPIES", "ESPLEES", "ESSE", "ESSEE", "ESSES", "ESSIE", "ESTH", "ESTHESES", "ESTHESIS", "ESTHESISES", "ESTHETE", "ESTHETES", "ETHS", "HEELLESS", "HEELS", "HEILS", "HEIST", "HEISTS", "HELLISH", "HELLS", "HELLSHIP", "HELPLESS", "HELPS", "HESPEL", "HESSITE", "HESSITES", "HEST", "HESTS", "HETHS", "HIES", "HILLIEST", "HILLS", "HILLSITE", "HILTLESS", "HILTS", "HIPLESS", "HIPPEST", "HIPPIES", "HIPPIEST", "HIPPISH", "HIPS", "HISH", "HISIS", "HISS", "HISSEL", "HISSES", "HIST", "HISTIE", "HISTS", "HITLESS", "HITS", "ILEITIS", "ILESITE", "ILLEIST", "ILLESS", "ILLEST", "ILLISH", "ILLITES", "ILLS", "IPHIS", "IPSE", "ISEPIPTESIS", "ISIS", "ISLE", "ISLELESS", "ISLES", "ISLET", "ISLETS", "ISLS", "ISSEI", "ISSEIS", "ISSITE", "ISTH", "ISTLE", "ISTLES", "LEES", "LEESE", "LEETS", "LEIS", "LEISS", "LESE", "LESLIE", "LESS", "LESSEE", "LESSEES", "LESSEESHIP", "LESSES", "LESSEST", "LEST", "LESTE", "LETHES", "LETS", "LETTISH", "LIES", "LIESH", "LIEST", "LILES", "LILIES", "LILTS", "LIPLESS", "LIPPIEST", "LIPS", "LIPSE", "LISE", "LISETTE", "LISH", "LISLE", "LISLES", "LISP", "LISPS", "LISS", "LISSES", "LIST", "LISTEL", "LISTELS", "LISTLESS", "LISTS", "LITES", "LITHEST", "LITHLESS", "LITS", "LITTLES", "LITTLEST", "LITTLISH", "PEELS", "PEEPS", "PEES", "PEISE", "PEISES", "PELES", "PELISSE", "PELISSES", "PELITES", "PELLETS", "PELTISH", "PELTLESS", "PELTS", "PEPLESS", "PEPPIEST", "PEPS", "PEPSI", "PEPSIS", "PESS", "PEST", "PESTE", "PESTIS", "PESTLE", "PESTLES", "PESTS", "PETITES", "PETITS", "PETS", "PETTIEST", "PETTISH", "PETTLES", "PHIES", "PHILIPPIST", "PHILLIPSITE", "PHILLIS", "PHIS", "PHTHISES", "PHTHISIS", "PIELESS", "PIES", "PIEST", "PIETIES", "PIETIST", "PIETISTS", "PIITIS", "PILELESS", "PILES", "PILIES", "PILIS", "PILLS", "PIPELESS", "PIPES", "PIPETS", "PIPETTES", "PIPIEST", "PIPITS", "PIPLESS", "PIPPIEST", "PIPS", "PISE", "PISH", "PISHES", "PISS", "PISSES", "PIST", "PISTE", "PISTIL", "PISTILS", "PISTLE", "PITHES", "PITHIEST", "PITHLESS", "PITHS", "PITIES", "PITILESS", "PITLESS", "PITS", "PLEIS", "PLIES", "PLISS", "PLISSE", "PLISSES", "PSEPHITE", "PSEPHITES", "PSIS", "PSST", "PTTS", "SEEL", "SEELS", "SEEP", "SEEPIEST", "SEEPS", "SEES", "SEESEE", "SEETHE", "SEETHES", "SEIS", "SEISE", "SEISES", "SEIT", "SELE", "SELL", "SELLE", "SELLES", "SELLI", "SELLIE", "SELLS", "SELS", "SELT", "SEPS", "SEPSES", "SEPSIS", "SEPT", "SEPTET", "SEPTETS", "SEPTETTE", "SEPTETTES", "SEPTI", "SEPTILE", "SEPTS", "SEPTSHIP", "SESELI", "SESS", "SESSILE", "SESTET", "SESTETS", "SESTI", "SETH", "SETHITE", "SETS", "SETT", "SETTEE", "SETTEES", "SETTLE", "SETTLES", "SHEE", "SHEEL", "SHEEP", "SHEEPISH", "SHEEPLESS", "SHEEPLET", "SHEEPSPLIT", "SHEET", "SHEETLESS", "SHEETLET", "SHEETS", "SHEITEL", "SHEL", "SHELL", "SHELLIEST", "SHELLS", "SHELTIE", "SHELTIES", "SHES", "SHETH", "SHIEL", "SHIELS", "SHIES", "SHIEST", "SHIH", "SHIITE", "SHILH", "SHILL", "SHILLET", "SHILLS", "SHILPIT", "SHILPITS", "SHIP", "SHIPLESS", "SHIPLET", "SHIPS", "SHIPT", "SHISH", "SHIST", "SHISTS", "SHIT", "SHITHEEL", "SHITS", "SHITTIEST", "SHITTLE", "SHLEP", "SHPT", "SHTETEL", "SHTETL", "SIEST", "SILE", "SILL", "SILLIES", "SILLIEST", "SILLS", "SILT", "SILTIEST", "SILTS", "SIPE", "SIPES", "SIPPET", "SIPPETS", "SIPPLE", "SIPS", "SISE", "SISEL", "SISES", "SISH", "SISI", "SISITH", "SISS", "SISSIES", "SISSIEST", "SIST", "SISTLE", "SITE", "SITES", "SITH", "SITHE", "SITHES", "SITI", "SITS", "SITTEE", "SLEE", "SLEEP", "SLEEPIEST", "SLEEPISH", "SLEEPLESS", "SLEEPS", "SLEET", "SLEETIEST", "SLEETS", "SLEPT", "SLETE", "SLIEST", "SLIP", "SLIPE", "SLIPES", "SLIPLESS", "SLIPPIEST", "SLIPS", "SLIPSHEET", "SLIPSTEP", "SLIPT", "SLISH", "SLIT", "SLITE", "SLITLESS", "SLITS", "SLITSHELL", "SPEEL", "SPEELLESS", "SPEELS", "SPEIL", "SPEILS", "SPEISE", "SPEISES", "SPEISS", "SPEISSES", "SPELL", "SPELLS", "SPELT", "SPELTS", "SPET", "SPETE", "SPETTLE", "SPIEL", "SPIELS", "SPIES", "SPILE", "SPILES", "SPILITE", "SPILL", "SPILLET", "SPILLPIPE", "SPILLS", "SPILT", "SPILTH", "SPILTHS", "SPISE", "SPISS", "SPIT", "SPITE", "SPITELESS", "SPITES", "SPITISH", "SPITS", "SPITTLE", "SPITTLES", "SPLEET", "SPLET", "SPLIT", "SPLITE", "SPLITS", "STEEL", "STEELE", "STEELIE", "STEELIES", "STEELIEST", "STEELLESS", "STEELS", "STEEP", "STEEPEST", "STEEPISH", "STEEPLE", "STEEPLELESS", "STEEPLES", "STEEPS", "STELE", "STELES", "STELL", "STELLITE", "STEP", "STEPHE", "STEPLESS", "STEPPE", "STEPPES", "STEPS", "STEPT", "STET", "STETS", "STIES", "STILE", "STILES", "STILET", "STILETTE", "STILL", "STILLEST", "STILLIEST", "STILLISH", "STILLS", "STILT", "STILTIEST", "STILTISH", "STILTS", "STIPE", "STIPEL", "STIPELS", "STIPES", "STIPITES", "STIPPLE", "STIPPLES", "STITE", "STITH", "STITHE", "STITHIES", "TEEPEES", "TEES", "TEEST", "TEETHES", "TEETHIEST", "TEETHLESS", "TEHSEEL", "TEHSIL", "TEISE", "TELES", "TELESES", "TELESIS", "TELLIES", "TELLIESES", "TELLS", "TEPEES", "TESS", "TESSEL", "TESSELLITE", "TEST", "TESTE", "TESTEE", "TESTEES", "TESTES", "TESTIEST", "TESTIS", "TESTITIS", "TESTS", "TETHS", "TETTISH", "THEETSEE", "THEIST", "THEISTS", "THELITIS", "THELITISES", "THESE", "THESES", "THESIS", "THETIS", "THILLS", "THIS", "THISLL", "THISTLE", "THISTLES", "THISTLISH", "THITSI", "THLIPSIS", "TIELESS", "TIES", "TILES", "TILLS", "TILS", "TILSIT", "TILTHS", "TILTS", "TIPIS", "TIPLESS", "TIPPETS", "TIPPIEST", "TIPPLES", "TIPS", "TIPSIEST", "TITHELESS", "TITHES", "TITIES", "TITIS", "TITLELESS", "TITLES", "TITLESHIP", "TITLIST", "TITLISTS", "TITS", "TITTIES", "TITTLES", "TSETSE", "TSETSES", "TSHI", "TSITSITH"]
        customGameOne.guessedWords = ["TITLES", "TITLESHIP", "TITLIST", "TITLISTS", "LISP", "SHIP", "SHIPS", "LISPS", "SITS", "SELL", "SELLS", "PIPES", "HEIST", "HEISTS", "ELLIPSE", "HEELS", "PETS"]
        
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }
    
    func createGermanDemoGames() {
        
        let moc = persistentContainer.viewContext
        
        let dailyGame = SpellingBeeGame(context: moc)
        dailyGame.isDaily = true
        dailyGame.isNew = true
        dailyGame.dateAdded = Date()
        dailyGame.lastPlayed = Date()
        dailyGame.correctWords = ["Testwort"]
        dailyGame.guessedWords = []
        dailyGame.language = "German"
        dailyGame.letters = ["I", "N", "R", "E", "L", "T", "D"]
        dailyGame.maxTime = 86400
        
        let customGameOne = SpellingBeeGame(context: moc)
        customGameOne.isDaily = false
        customGameOne.isNew = false
        customGameOne.dateAdded = Date(timeIntervalSinceNow: -10)
        customGameOne.lastPlayed = Date()
        customGameOne.correctWords = ["DEGENS", "DESIGN", "DESSIN", "DIESE", "DIESEN", "DIESES", "DISSENS", "EDENS", "EIDES", "EIGENSINN", "EIGENSINNES", "EINES", "EINSEN", "EISEN", "EISENS", "EISES", "ENDES", "ESSIG", "ESSIGS", "GEISS", "GEISSEN", "GESINDE", "ISIS", "JEDES", "JENS", "NEIDES", "NEISSE", "NESSIE", "SEEN", "SEES", "SEGEN", "SEGENS", "SEIDE", "SEIN", "SEINEN", "SEINS", "SIEG", "SIEGS", "SIGI", "SIND", "SINN", "SINNEN", "SINNES", "DEINES", "DESJENIGEN", "DESSEN", "DIENENDES", "DIES", "DIESIG", "DIESJENIGEN", "EIGENES", "EIGENSINNIG", "EIGENSINNIGE", "EIGENSINNIGES", "EIGNES", "EINGESESSENEN", "EINGIESSEN", "EINIGES", "EINSENDEN", "EINSENDEND", "EINSENDENDEN", "EINSENDENDES", "EISIG", "EISIGEN", "EISIGES", "ENGES", "ESSE", "ESSEND", "ESSENDEN", "ESSENDES", "GEDIEGENES", "GEGESSEN", "GEGESSENE", "GEGESSENEN", "GEGESSENES", "GENESE", "GENESEN", "GENESENDE", "GENESENDEN", "GENESENE", "GENESENEN", "GENIESSE", "GENIESSEND", "GENIESSENDE", "GENIESSENDEN", "GENIESSENDES", "GESESSEN", "GESESSENE", "GESESSENEN", "GESESSENES", "GIESSE", "GIESSEN", "GIESSEND", "GIESSENDEN", "GIESSENDES", "INDES", "INDESSEN", "INNIGES", "JENES", "NEIDENDES", "NIESE", "NIESEN", "NIESEND", "NIESENDEN", "NIESENDES", "SEGNE", "SEGNEND", "SEGNENDE", "SEGNENDES", "SEID", "SEIDENE", "SEIDENEN", "SEIDENES", "SEIDIG", "SEIDIGE", "SEIDIGEN", "SEIDIGES", "SEIEND", "SEIENDE", "SEIENDEN", "SEIENDES", "SEINE", "SEINES", "SEINIGE", "SEINIGEN", "SEND", "SENDE", "SENDEN", "SENGEN", "SENGEND", "SENGENDE", "SIEDEN", "SIEDEND", "SIEDENDE", "SIEDENDES", "SIEGE", "SIEGEND", "SIEGENDE", "SIEGENDEN", "SIEGENDES", "SINGE", "SINGEN", "SINGEND", "SINGENDEN", "SINGENDES", "SINNENDE", "SINNENDEN", "SINNIGE", "SINNIGEN", "SINNIGES", "ESSEN", "GINSENG", "SENSE", "DEISE", "EINS", "SEGNEN", "SENDENS", "SINNE", "GENIESSEN", "SEIEN", "SENDENDEN", "SIEGEN"]
        customGameOne.guessedWords = ["EISIGES", "EISIGEN", "EISIG", "GIESSEN", "EISEN", "EISENS", "EISES", "ENDES", "DIESEN", "DIESES", "ESSIG", "DIESE", "DESIGN", "ESSEN", "GENIESSEN", "SENDEN"]
        customGameOne.language = "German"
        customGameOne.letters = ["S", "N", "D", "I", "G", "E", "J"]
        customGameOne.maxTime = 0
        
        let customGameTwo = SpellingBeeGame(context: moc)
        customGameTwo.isDaily = false
        customGameTwo.isNew = false
        customGameTwo.dateAdded = Date(timeIntervalSinceNow: -5)
        customGameTwo.lastPlayed = Date()
        customGameTwo.correctWords = ["BERGE", "BERGEN", "BERGNOT", "BOEGEN", "BOGEN", "BONGO", "BROTGEBER", "BROTGEBERN", "EGGE", "EGON", "ERGO", "ERREGERN", "GEBEN", "GEBER", "GEBERN", "GEBET", "GEBETEN", "GEBORENEN", "GEBOTE", "GEBOTEN", "GEGENTOR", "GEGNER", "GENEN", "GENRE", "GEORG", "GEORGE", "GERTE", "GOENNER", "GOENNERN", "GOERE", "GOETEBORG", "GOETTERBOTE", "GOETTERN", "GONG", "GOTT", "GRETE", "GROB", "GROG", "GROTTE", "GROTTEN", "NEGER", "NEGRO", "OREGON", "REGEN", "REGENBOEGEN", "REGENT", "REGER", "ROGER", "ROGGENBROT", "ROGGENERNTE", "BEGEBEN", "BEGEGNE", "BEGEGNEN", "BEGEGNET", "BEGEGNETE", "BEGEGNETEN", "BEGEGNETER", "BEGEGNETET", "BEGONNENE", "BEGONNENEN", "BETROGEN", "BETROGENE", "BETROGENEN", "BETROGET", "BOGET", "BORGE", "BORGT", "BORGTEN", "BORGTET", "ENGE", "ENGEN", "ENGER", "ENGEREN", "ENGERER", "ENGT", "ENTGEGENGETRETEN", "ENTGEGENGETRETENE", "ENTGEGENGETRETENEN", "ENTGEGENTRETEN", "ENTGEGNE", "ENTGEGNET", "ENTGEGNETEN", "ENTGEGNETET", "ERGEBE", "ERGEBEN", "ERGEBENEN", "ERGEBENER", "ERREGEN", "ERREGT", "ERREGTE", "ERREGTEN", "ERREGTET", "GEBE", "GEBEBT", "GEBETTET", "GEBETTETEN", "GEBOGEN", "GEBOGENE", "GEBOGENER", "GEBORENE", "GEBORENER", "GEBORGEN", "GEBORGENE", "GEBORGENER", "GEBORGT", "GEBORGTER", "GEBOTENE", "GEBOTENEN", "GEBOTENER", "GEBT", "GEENTERTE", "GEENTERTEN", "GEERBTE", "GEERBTEN", "GEERBTER", "GEERNTET", "GEERNTETE", "GEERNTETEN", "GEGEBENE", "GEGEBENEN", "GEGEBENER", "GEGEN", "GEGOENNT", "GEORTET", "GEORTETE", "GEORTETER", "GERBEN", "GEREGNET", "GERETTET", "GERETTETE", "GERETTETEN", "GERETTETER", "GERN", "GERNE", "GEROENTGT", "GEROETETER", "GERONNEN", "GERONNENE", "GERONNENER", "GETEERTE", "GETEERTEN", "GETOBT", "GETOENTE", "GETOENTEN", "GETOETET", "GETOETETE", "GETOETETEN", "GETOETETER", "GETRENNT", "GETRENNTEN", "GETRENNTER", "GETRETENE", "GETRETENEN", "GETRETENER", "GETROTTET", "GETROTTETE", "GETROTTETER", "GOENNE", "GOENNT", "GOTTGEGEBENE", "GROBEN", "GROBER", "GROBEREN", "GROBERER", "REGEREN", "REGNEN", "REGNET", "REGNETE", "REGT", "REGTE", "ROENTGEN", "TOTGEBOREN", "TOTGEBORENE", "TOTGEBORENEN", "TOTGEBORENER", "BERG", "REGENBOGEN", "ROGGEN", "GEBETE", "GEBOT", "GEGEBEN", "BEGONNEN", "ENGERE", "ENGTE", "ENTGEGEN", "ERGEBENE", "GEBOOTET", "GEBOREN", "GEERBT", "GERONNENEN", "GETRENNTE", "GETRETEN", "GROBE", "REGE"]
        customGameTwo.guessedWords = ["ERREGTE", "ERREGTEN", "ERREGTET", "GEBE", "GEBEBT", "GEBETTET", "GEBETTETEN", "GEBOGEN", "GEBOGENE", "GEBOGENER", "GEBORENE", "GEBORENER", "GEBORGEN", "GEBORGENE", "GEBORGENER", "GEBORGT", "GEBORGTER", "GEBOTENE", "GEBOTENEN", "GEBOTENER", "GEBT", "GEENTERTE", "GEENTERTEN", "GEERBTE", "GEERBTEN", "GEERBTER", "GEERNTET", "GEERNTETE", "GEERNTETEN", "GEGEBENE", "GEGEBENEN", "GEGEBENER", "GEGEN", "GEGOENNT", "GEORTET", "GEORTETE", "GEORTETER", "GERBEN", "GEREGNET", "GERETTET", "GERETTETE", "GERETTETEN", "GERETTETER", "GERN"]
        customGameTwo.language = "German"
        customGameTwo.letters = ["G", "N", "O", "B", "R", "T", "E"]
        customGameTwo.maxTime = 0
        
        let customGameThree = SpellingBeeGame(context: moc)
        customGameThree.isDaily = false
        customGameThree.isNew = false
        customGameThree.dateAdded = Date(timeIntervalSinceNow: 0)
        customGameThree.lastPlayed = Date()
        customGameThree.correctWords = ["BREMSE", "BREMSWEG", "BREMSWEGE", "MEER", "MEERE", "MEERES", "MEERS", "MESSE", "BEMESSE", "BESSEREM", "REGEM", "MESSER", "MESS", "MESSBER", "WEGMESSER"]
        customGameThree.guessedWords = []
        customGameThree.language = "German"
        customGameThree.letters = ["M", "G", "S", "R", "B", "W", "E"]
        customGameThree.maxTime = 86400
        
        do {
            try moc.save()
        } catch {
            print(error)
        }
    }
    
    func deleteAllGames() {
        
        let moc = persistentContainer.viewContext
        
        let gameRequest: NSFetchRequest<SpellingBeeGame> = SpellingBeeGame.fetchRequest()
        gameRequest.returnsObjectsAsFaults = false
        
        var games = [SpellingBeeGame]()
        
        do {
            games = try moc.fetch(gameRequest)
        } catch {
            print(error)
        }
        
        for game in games {
            moc.delete(game)
        }
        
        do {
            try moc.save()
        } catch {
            print(error)
        }
        
        
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let moc = persistentContainer.viewContext
        
        if Defaults.isAppAlreadyLaunchedOnce() == false {

            if Defaults.currentStandardLanguage() == .english {

                // Creates first daily game in english
                CoreData.saveNewGame(isDaily: true,
                                     maxTime: Int64(86400), // = 1 day
                                     correctWords: ["CIRCUIT", "CIRCULI", "CIRCULIN", "CIRCUT", "CITRUL", "CITRULLIN", "CRITTUR", "CRULL", "CRUNT", "CRUT", "CUCULI", "CUIR", "CUIT", "CULL", "CULT", "CULTI", "CULTIC", "CUNICULI", "CUNILI", "CUNIT", "CUNNI", "CUNT", "CURIN", "CURL", "CURN", "CURR", "CURT", "CURUCUCU", "CURUCUI", "CUTIN", "INCULT", "INCUR", "INCUT", "INNUIT", "INRUN", "INTUIT", "INTURN", "INULIN", "INUNCT", "INURN", "LICURI", "LITU", "LITUI", "LULL", "LULU", "LUNN", "LUNT", "LURI", "LUTRIN", "NINTU", "NINUT", "NUCIN", "NULL", "NUNC", "NUNNI", "NURL", "RUIN", "RULL", "RUNIC", "RUNT", "RURU", "RUTIC", "RUTIN", "RUTULI", "TICUL", "TITULI", "TRULL", "TRULLI", "TRUN", "TUCUTUCU", "TULNIC", "TULU", "TUNIC", "TUNICIN", "TUNNIT", "TUNU", "TURCIC", "TURI", "TURN", "TURR", "TURTUR", "TURURI", "TUTIN", "TUTTI", "TUTU", "TUTUTNI", "ULLUCU", "ULULU", "UNCI", "UNCINCT", "UNCINI", "UNCT", "UNCURL", "UNCUT", "UNINN", "UNIT", "UNLIT", "UNRUN", "UNTIL", "UNTILL", "UNTILT", "UNTIN", "UNTINCT", "UNTRILL", "UNTURN", "UNURN", "URIC", "URUCU", "URUCURI", "URUTU", "UTIL", "UTRICUL", "UTRICULI", "UTURUNCU"],
                                     letters: ["U", "N", "C", "R", "L", "T", "I"],
                                     language: Defaults.currentStandardLanguage())

                // Creates first custom game in english
                CoreData.saveNewGame(isDaily: false,
                                     maxTime: Int64(604800), // = 1 week
                                     correctWords: ["EELIEST", "EELS", "EISELL", "ELITES", "ELITIST", "ELITISTS", "ELLIPSE", "ELLIPSES", "ELLIPSIS", "ELLS", "ELSE", "ELSES", "EPEEIST", "EPEEISTS", "EPEES", "EPHELIS", "EPILEPSIES", "EPIST", "EPISTLE", "EPISTLES", "EPITHESIS", "EPITHETS", "EPPES", "ESES", "ESPIES", "ESPLEES", "ESSE", "ESSEE", "ESSES", "ESSIE", "ESTH", "ESTHESES", "ESTHESIS", "ESTHESISES", "ESTHETE", "ESTHETES", "ETHS", "HEELLESS", "HEELS", "HEILS", "HEIST", "HEISTS", "HELLISH", "HELLS", "HELLSHIP", "HELPLESS", "HELPS", "HESPEL", "HESSITE", "HESSITES", "HEST", "HESTS", "HETHS", "HIES", "HILLIEST", "HILLS", "HILLSITE", "HILTLESS", "HILTS", "HIPLESS", "HIPPEST", "HIPPIES", "HIPPIEST", "HIPPISH", "HIPS", "HISH", "HISIS", "HISS", "HISSEL", "HISSES", "HIST", "HISTIE", "HISTS", "HITLESS", "HITS", "ILEITIS", "ILESITE", "ILLEIST", "ILLESS", "ILLEST", "ILLISH", "ILLITES", "ILLS", "IPHIS", "IPSE", "ISEPIPTESIS", "ISIS", "ISLE", "ISLELESS", "ISLES", "ISLET", "ISLETS", "ISLS", "ISSEI", "ISSEIS", "ISSITE", "ISTH", "ISTLE", "ISTLES", "LEES", "LEESE", "LEETS", "LEIS", "LEISS", "LESE", "LESLIE", "LESS", "LESSEE", "LESSEES", "LESSEESHIP", "LESSES", "LESSEST", "LEST", "LESTE", "LETHES", "LETS", "LETTISH", "LIES", "LIESH", "LIEST", "LILES", "LILIES", "LILTS", "LIPLESS", "LIPPIEST", "LIPS", "LIPSE", "LISE", "LISETTE", "LISH", "LISLE", "LISLES", "LISP", "LISPS", "LISS", "LISSES", "LIST", "LISTEL", "LISTELS", "LISTLESS", "LISTS", "LITES", "LITHEST", "LITHLESS", "LITS", "LITTLES", "LITTLEST", "LITTLISH", "PEELS", "PEEPS", "PEES", "PEISE", "PEISES", "PELES", "PELISSE", "PELISSES", "PELITES", "PELLETS", "PELTISH", "PELTLESS", "PELTS", "PEPLESS", "PEPPIEST", "PEPS", "PEPSI", "PEPSIS", "PESS", "PEST", "PESTE", "PESTIS", "PESTLE", "PESTLES", "PESTS", "PETITES", "PETITS", "PETS", "PETTIEST", "PETTISH", "PETTLES", "PHIES", "PHILIPPIST", "PHILLIPSITE", "PHILLIS", "PHIS", "PHTHISES", "PHTHISIS", "PIELESS", "PIES", "PIEST", "PIETIES", "PIETIST", "PIETISTS", "PIITIS", "PILELESS", "PILES", "PILIES", "PILIS", "PILLS", "PIPELESS", "PIPES", "PIPETS", "PIPETTES", "PIPIEST", "PIPITS", "PIPLESS", "PIPPIEST", "PIPS", "PISE", "PISH", "PISHES", "PISS", "PISSES", "PIST", "PISTE", "PISTIL", "PISTILS", "PISTLE", "PITHES", "PITHIEST", "PITHLESS", "PITHS", "PITIES", "PITILESS", "PITLESS", "PITS", "PLEIS", "PLIES", "PLISS", "PLISSE", "PLISSES", "PSEPHITE", "PSEPHITES", "PSIS", "PSST", "PTTS", "SEEL", "SEELS", "SEEP", "SEEPIEST", "SEEPS", "SEES", "SEESEE", "SEETHE", "SEETHES", "SEIS", "SEISE", "SEISES", "SEIT", "SELE", "SELL", "SELLE", "SELLES", "SELLI", "SELLIE", "SELLS", "SELS", "SELT", "SEPS", "SEPSES", "SEPSIS", "SEPT", "SEPTET", "SEPTETS", "SEPTETTE", "SEPTETTES", "SEPTI", "SEPTILE", "SEPTS", "SEPTSHIP", "SESELI", "SESS", "SESSILE", "SESTET", "SESTETS", "SESTI", "SETH", "SETHITE", "SETS", "SETT", "SETTEE", "SETTEES", "SETTLE", "SETTLES", "SHEE", "SHEEL", "SHEEP", "SHEEPISH", "SHEEPLESS", "SHEEPLET", "SHEEPSPLIT", "SHEET", "SHEETLESS", "SHEETLET", "SHEETS", "SHEITEL", "SHEL", "SHELL", "SHELLIEST", "SHELLS", "SHELTIE", "SHELTIES", "SHES", "SHETH", "SHIEL", "SHIELS", "SHIES", "SHIEST", "SHIH", "SHIITE", "SHILH", "SHILL", "SHILLET", "SHILLS", "SHILPIT", "SHILPITS", "SHIP", "SHIPLESS", "SHIPLET", "SHIPS", "SHIPT", "SHISH", "SHIST", "SHISTS", "SHIT", "SHITHEEL", "SHITS", "SHITTIEST", "SHITTLE", "SHLEP", "SHPT", "SHTETEL", "SHTETL", "SIEST", "SILE", "SILL", "SILLIES", "SILLIEST", "SILLS", "SILT", "SILTIEST", "SILTS", "SIPE", "SIPES", "SIPPET", "SIPPETS", "SIPPLE", "SIPS", "SISE", "SISEL", "SISES", "SISH", "SISI", "SISITH", "SISS", "SISSIES", "SISSIEST", "SIST", "SISTLE", "SITE", "SITES", "SITH", "SITHE", "SITHES", "SITI", "SITS", "SITTEE", "SLEE", "SLEEP", "SLEEPIEST", "SLEEPISH", "SLEEPLESS", "SLEEPS", "SLEET", "SLEETIEST", "SLEETS", "SLEPT", "SLETE", "SLIEST", "SLIP", "SLIPE", "SLIPES", "SLIPLESS", "SLIPPIEST", "SLIPS", "SLIPSHEET", "SLIPSTEP", "SLIPT", "SLISH", "SLIT", "SLITE", "SLITLESS", "SLITS", "SLITSHELL", "SPEEL", "SPEELLESS", "SPEELS", "SPEIL", "SPEILS", "SPEISE", "SPEISES", "SPEISS", "SPEISSES", "SPELL", "SPELLS", "SPELT", "SPELTS", "SPET", "SPETE", "SPETTLE", "SPIEL", "SPIELS", "SPIES", "SPILE", "SPILES", "SPILITE", "SPILL", "SPILLET", "SPILLPIPE", "SPILLS", "SPILT", "SPILTH", "SPILTHS", "SPISE", "SPISS", "SPIT", "SPITE", "SPITELESS", "SPITES", "SPITISH", "SPITS", "SPITTLE", "SPITTLES", "SPLEET", "SPLET", "SPLIT", "SPLITE", "SPLITS", "STEEL", "STEELE", "STEELIE", "STEELIES", "STEELIEST", "STEELLESS", "STEELS", "STEEP", "STEEPEST", "STEEPISH", "STEEPLE", "STEEPLELESS", "STEEPLES", "STEEPS", "STELE", "STELES", "STELL", "STELLITE", "STEP", "STEPHE", "STEPLESS", "STEPPE", "STEPPES", "STEPS", "STEPT", "STET", "STETS", "STIES", "STILE", "STILES", "STILET", "STILETTE", "STILL", "STILLEST", "STILLIEST", "STILLISH", "STILLS", "STILT", "STILTIEST", "STILTISH", "STILTS", "STIPE", "STIPEL", "STIPELS", "STIPES", "STIPITES", "STIPPLE", "STIPPLES", "STITE", "STITH", "STITHE", "STITHIES", "TEEPEES", "TEES", "TEEST", "TEETHES", "TEETHIEST", "TEETHLESS", "TEHSEEL", "TEHSIL", "TEISE", "TELES", "TELESES", "TELESIS", "TELLIES", "TELLIESES", "TELLS", "TEPEES", "TESS", "TESSEL", "TESSELLITE", "TEST", "TESTE", "TESTEE", "TESTEES", "TESTES", "TESTIEST", "TESTIS", "TESTITIS", "TESTS", "TETHS", "TETTISH", "THEETSEE", "THEIST", "THEISTS", "THELITIS", "THELITISES", "THESE", "THESES", "THESIS", "THETIS", "THILLS", "THIS", "THISLL", "THISTLE", "THISTLES", "THISTLISH", "THITSI", "THLIPSIS", "TIELESS", "TIES", "TILES", "TILLS", "TILS", "TILSIT", "TILTHS", "TILTS", "TIPIS", "TIPLESS", "TIPPETS", "TIPPIEST", "TIPPLES", "TIPS", "TIPSIEST", "TITHELESS", "TITHES", "TITIES", "TITIS", "TITLELESS", "TITLES", "TITLESHIP", "TITLIST", "TITLISTS", "TITS", "TITTIES", "TITTLES", "TSETSE", "TSETSES", "TSHI", "TSITSITH"],
                                     letters: ["S", "T", "E", "I", "P", "H", "L"],
                                     language: Defaults.currentStandardLanguage())

            } else if Defaults.currentStandardLanguage() == .german {

                // Creates first daily game in german
                CoreData.saveNewGame(isDaily: true,
                                     maxTime: Int64(86400), // = 1 day
                                     correctWords: ["ACHTEN", "AEHREN", "AERA", "AETNA", "AHNHERREN", "ANRECHT", "ANRECHTEN", "ANTENNEN", "ARENA", "ARENEN", "ATHEN", "ATHENE", "ATTACHE", "ATTENTA", "ATTENTAETER", "ATTENTAT", "CENT", "CENTER", "CHANCEN", "CHARTER", "ECHTE", "EHEN", "EHER", "EHRE", "EHREN", "EHRENRECHTE", "ENTE", "ERNAEHRER", "ERNAEHRERN", "ERNTE", "ERRECHNEN", "ERRETTER", "ERRETTERN", "ETAT", "ETHERNET", "HAAREN", "HAEHNCHEN", "HAEHNEN", "HAERTE", "HAETTEN", "HANNE", "HARTE", "HECHTE", "HEER", "HEEREN", "HENNE", "HERA", "HERR", "HERREN", "NAECHTE", "NAECHTEN", "NAEHE", "NAEHERE", "NAEHTEN", "NAHEN", "NENNER", "NETTE", "RACHE", "RAECHER", "RAETE", "RATEN", "RATTE", "RECHERCHE", "RECHNEN", "RECHNER", "RECHNERN", "RECHT", "RECHTEN", "REHE", "RENNEN", "RENNER", "RENTE", "RETTER", "RETTERN", "TAETER", "TAETERN", "TANNEN", "TANTE", "TARENT", "TATEN", "TEHERAN", "TENNE",  "THEATER", "THEATERN", "TRAENEN", "TRANCE", "TRANCEN", "TRANCHE", "TRATTE", "TRATTEN", "TRENNEN", "ACHTE", "ACHTET", "ACHTETEN", "AECHTEN", "AHNEN", "AHNTE", "AHNTEN", "AHNTET", "ANNAEHEN", "ANNAEHERN", "ANNAEHERT", "ANRATEN", "ANRECHNEN", "ANRENNEN", "ANTRATEN", "ARTETE", "CETERA", "CHARTERTEN", "ECHT", "ECHTEN", "ECHTER", "EHRT", "EHRTE", "EHRTET", "ENTARTE", "ENTARTEN", "ENTARTET", "ENTARTETE", "ENTARTETER", "ENTEHRT", "ENTENTE", "ENTERE", "ENTERN", "ENTERT", "ENTERTE", "ENTERTEN", "ENTHAARE", "ENTHAART", "ENTHAARTEN", "ENTHAARTER", "ENTHAARTET", "ENTRANN", "ENTRANNEN", "ENTRANNET", "ENTRECHTETEN", "ENTTARNT", "ERACHTE", "ERACHTET", "ERACHTETEN", "ERAHNEN", "ERHAERTEN", "ERHAERTETE", "ERHAERTETEN", "ERNAEHREN", "ERNAEHRTE", "ERNAEHRTEN", "ERNAEHRTER", "ERNAEHRTET", "ERNANNTE", "ERNANNTEN", "ERNANNTER", "ERNANNTET", "ERNENNE", "ERNENNT", "ERNTET", "ERNTETE", "ERNTETEN", "ERNTETET", "ERRAET", "ERRATE", "ERRATEN", "ERRATENE", "ERRATENEN", "ERRATENER", "ERRECHNE", "ERRECHNET", "ERRECHNETE", "ERRECHNETEN", "ERRECHNETET", "ERRETTE", "ERRETTET", "ERRETTETEN", "ERRETTETER", "ERRETTETET", "HAERTEN", "HAERTERE", "HAERTEREN", "HAETTE", "HAETTET", "HARREN", "HARRTE", "HARRTEN", "HARTEN", "HARTER", "HATTEN", "HATTET", "HECHTEN", "HERAN", "HERANTRAT", "HERANTRATEN", "HERNACH", "NACHHER", "NACHRECHNEN", "NACHRENNEN", "NAEHER", "NAEHEREN", "NAEHERER", "NAEHERT", "NAEHERTEN", "NAEHERTET", "NAEHREN", "NAEHRT", "NAEHRTE", "NAEHRTEN", "NAEHRTET", "NAEHT", "NAEHTET", "NAHE", "NAHTE", "NAHTET", "NANNTE", "NANNTET", "NARREN", "NARRTE", "NENNE", "NENNEN", "NENNT", "NETTEN", "NETTER", "NETTEREN", "NETTERER", "RAECHE", "RAECHT", "RAECHTEN", "RAECHTET", "RAET", "RANNTE", "RANNTEN", "RARE", "RARER", "RARERE", "RARERER", "RATET", "RATTERE", "RATTERN", "RATTERT", "RATTERTE", "RATTERTET", "RECHEN", "RECHNE", "RECHNET", "RECHNETE", "RECHNETET", "RENNE", "RETTE", "RETTEN", "RETTETE", "RETTETEN", "RETTETET", "TAET", "TAETE", "TAETEN", "TARNEN", "TARNTE", "TARNTEN", "TATET", "TEERE", "TEEREN", "TEERT", "TEERTEN", "TEERTET", "TRACHTE", "TRACHTEN", "TRACHTET", "TRACHTETE", "TRACHTETEN", "TRACHTETET", "TRATEN", "TRATET", "TRENNE", "TRENNT", "TRENNTEN", "TRENNTET", "TRETEN", "HAARE", "TEER", "TRAENE", "ERNTEN", "NAEHEN", "NETT", "ANTENNE", "ARTEN", "HAERTER", "HERRN", "RECHERCHEN", "RECHTER", "RENTNER", "TETRA", "TRENN", "TRETERN", "ANTRETEN", "HATTE", "NAHETRETEN", "RECHTE", "RENNT", "TRETE"],
                                     letters: ["E", "H", "N", "R", "C", "A", "T"],
                                     language: Defaults.currentStandardLanguage())

                // Creates first custom game in german
                CoreData.saveNewGame(isDaily: false,
                                     maxTime: Int64(604800), // = 1 week
                                     correctWords: ["AERA", "AMERIKA", "AMERIKANERIN", "AMERIKANERINNEN", "AMERIKANERN", "ANKER", "ARENA", "ARENEN", "ARIE", "ARIEN", "ARIER", "ARMEE", "ARMEN", "ARMENIEN", "ARMENIER", "EIERN", "EIMER", "EIMERN", "EINER", "ERINNERN", "ERKENNEN", "INNEREIEN", "INNEREN", "INNERN", "IRAK", "IRAN", "IREN", "IRIN", "KAEMMEREI", "KAEMMERER", "KAEMMERERN", "KAMERA", "KAMERAMAENNER", "KAMERAMANN", "KAMMER", "KARRE", "KARREN", "KARRIERE", "KEINER", "KENNER", "KENNERINNEN", "KENNERMIENE", "KENNERN", "KENNMARKE", "KERAMIK", "KERAMIKERN", "KERKERN", "KERNE", "KRAEMER", "KRAM", "KRAN", "KRANKE", "KREME", "KRIM", "KRIMI", "MAAR", "MAENNER", "MANIER", "MARIANNE", "MARIE", "MARINE", "MARINEN", "MARK", "MARKEN", "MARKENEIER", "MARKENNAMEN", "MEER", "MEERE", "MEEREN", "MEIER", "NENNER", "NIERE", "NIEREN", "REIM", "REIN", "REINER", "RENNEN", "RENNER", "RIEMEN", "AERMER", "AERMERE", "AERMEREM", "AERMERER", "ANERKENNEN", "ANIMIERE", "ANIMIEREN", "ANKERE", "ANMERKEN", "ANRENNEN", "ARMEM", "EINRENKEN", "EINRENNE", "EINRENNEN", "ERINNERE", "ERKRANKE", "ERNENNE", "IMKERN", "INNER", "INNEREM", "INNERER", "IRREN", "IRRER", "KARIKIEREN", "KNARREN", "KRAENKEN", "KRAENKERE", "KRAENKEREN", "KRAENKERER", "KRAME", "KRANK", "KRANKEM", "KRANKEN", "KRANKER", "KREIERE", "KREIEREN", "MARINIERE", "MARKIEREN", "MERK", "MERKE", "MERKEN", "NARREN", "NIMMER", "RAMME", "RAMMEN", "RANKEN", "RARE", "RAREM", "RARER", "RARERE", "RAREREM", "RARERER", "REIME", "REINEM", "REINEN", "REINERE", "REINEREN", "REINERER", "RENNE", "RINNEN", "KERN", "RANKE", "RINNE", "IMMER", "AMERIKANER", "ANKERN", "ARME", "EIER", "INNERE", "KAMMERN", "KERAMIKEN", "MANIEREN", "MARKE", "MEINER", "MERKER", "RAINEN", "RAIN", "REINE", "ARMER", "IRRE", "IRREM"],
                                     letters: ["R", "I", "E", "A", "N", "K", "M"],
                                     language: Defaults.currentStandardLanguage())

            }
        }
        
        
//        createEnglishDemoGames()
//        createGermanDemoGames()
        
//        deleteAllGames()
        
        

//        do {
//            try moc.save()
//        } catch {
//            print(error)
//        }
        
//        let gameRequest: NSFetchRequest<SpellingBeeGame> = SpellingBeeGame.fetchRequest()
//        gameRequest.returnsObjectsAsFaults = false
//
////        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: true)
////        gameRequest.sortDescriptors = [sortDescriptor]
//
//        var games = [SpellingBeeGame]()
//
//        do {
//            games = try moc.fetch(gameRequest)
//            print(games)
//
//            for game in games {
//                print("\n\nCORRECT WORDS\n")
//                print(game.correctWords!)
//                print("\n\n")
//            }
//
//        } catch {
//            print(error)
//        }

        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SpellingBee")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

