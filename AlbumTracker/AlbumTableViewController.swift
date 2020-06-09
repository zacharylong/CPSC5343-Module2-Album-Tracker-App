//
//  AlbumTableViewController.swift
//  AlbumTracker
//
//  Created by Zachary Long on 6/7/20.
//  Copyright © 2020 Zachary Long. All rights reserved.
//

import UIKit
import os.log

class AlbumTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var albums = [Album]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use the edit button provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        //Load any saved albums, otherwise load sample data
        if let savedAlbums = loadAlbums() {
            albums += savedAlbums
        } else {
            //Load the sample data
            loadSampleAlbums()
        }
        
        //Load the sample data
        //loadSampleAlbums()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return albums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let cellIdentifier = "AlbumTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlbumTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AlbumTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let album = albums[indexPath.row]
        
        // Configure the cell...
        cell.albumNameLabel.text = album.name
        cell.artistNameLabel.text = album.artist
        cell.albumImageView.image = album.photo

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // Delete the row from the data source
            albums.remove(at: indexPath.row)
            saveAlbums()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new album.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let albumDetailViewController = segue.destination as? AlbumDetailViewController
                else {
                    fatalError("Unexpected Destination: \(segue.destination)")
            }
            
            guard let selectedAlbumCell = sender as? AlbumTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedAlbumCell) else {
                fatalError("The expected cell is not being displayed by the table")
            }
            
            let selectedAlbum = albums[indexPath.row]
            albumDetailViewController.album = selectedAlbum
            
        default:
            fatalError("Unexpected segue identifier; \(String(describing: segue.identifier))")
        }
    }

    
    //MARK: Actions
   @IBAction func unwindToAlbumList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AlbumDetailViewController, let album = sourceViewController.album {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing album
                albums[selectedIndexPath.row] = album
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                
                // Add a new meal.
                let newIndexPath = IndexPath(row: albums.count, section: 0)
                
                albums.append(album)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            
            //Save the albums
            saveAlbums()
            
        }
    }
        
    //MARK: Private Methods
    
    private func loadSampleAlbums() {
        
        let photo1 = UIImage(named: "Balance005")
        let photo2 = UIImage(named: "Hyperfall")

        let photo3 = UIImage(named: "LastNight")
        let photo4 = UIImage(named: "MBDTF")
        let photo5 = UIImage(named: "MetaphoricalMusic")
        let photo6 = UIImage(named: "ModalMusic")
        let photo7 = UIImage(named: "MusicForTheJilted")
        let photo8 = UIImage(named: "Photek")
        let photo9 = UIImage(named: "Pryda")
        let photo10 = UIImage(named: "Random")
        let photo11 = UIImage(named: "SpiritualState")
        let photo12 = UIImage(named: "TheGifted")
        
//        guard let album1 = Album(name: "Balance 005", artist: "James Holden", photo: photo1) else { fatalError("Unable to instantiate")
//            }
//        guard let album2 = Album(name: "Hyperfall", artist: "Yotto", photo: photo2) else { fatalError("Unable to instantiate")
//        }
        
        let album1 = Album(name: "Balance 005", artist: "James Holden", year: "2003", recordLabel: "EQ Recordings", photo: photo1, trackList: """
                                CD 1
                                01. The MFA – The Difference It Makes (Original Mix)
                                02. Meta.83 – Metalgroove ep:Antrieb
                                03. Jake Fairley – Oshawa
                                04. Zeta Reticula – Tool 1
                                05. Petter – All Together
                                06. Baby Ford & The Ifach Collective – Bad Friday
                                07. Zeta Reticula – Tool 3
                                08. Avus – Real
                                09. DJ ESP – No Future ep:No Future (Soundburnt mix)
                                10. Jase From Outta Space featuring Claire – Do What You Want (Infusion’s Sky mix)
                                11. Nathan Fake – Outhouse (Fluffy mix)
                                12. Nathan Fake – Outhouse (Original Mix)
                                13. FortDax – Fortune Telling Fish, Curled to Suggest ‘Home’
                                14. PQM – You Are Sleeping (PQM meets Luke Chable Vocal pass)
                                15. Petter – These Days (Instrumental)**
                                16. Herrmann & Klein – Leaving You Behind (Without Knowing Where To Go)
                                ** Includes Beats of Baby Ford & The Ifach Collective – Bad Friday

                                CD 2
                                01. Meek – Happy
                                02. Meerkat – Colours (JH re-edit)
                                03. Avus – Your Body (Original Mix)
                                04. Scape One – PFX Tokyo
                                05. FC Kahuna – Hayling (Kosmas Epilson mix)
                                06. Holden – The Wheel (Pass 1)
                                07. Kotai + Mo – Black Acid pt 1
                                08. Epsilon 9 – Lifeformation (Infimal Machine mix)
                                09. Carl A Finlow – Ghetto Server
                                10. Gill Norris – Forme
                                11. Ficta – Eli
                                12. Petter – Tonediary
                                13. Form & Function – Wonderland (Original Mix)
                                14. Meta.83 – Metalgroove ep:End Titles
                                """)
        let album2 = Album(name: "Hyperfall", artist: "Yotto", year: "2018", recordLabel: "Anjunadeep", photo: photo2, trackList: """
                                1. Yotto - Hyperfall
                                2. Yotto Feat. Vök - The One You Left Behind
                                3. Yotto - Kantsu
                                4. Yotto - Nada C
                                5. Yotto - Turn It Around
                                6. Yotto Feat. CAPS (2) - Epilogue
                                7. Yotto - Outsight
                                8. Yotto - Odd One Out
                                9. Yotto    Hyperlude
                                10. Yotto    Radiate
                                11. Yotto Feat. Sønin & Laudic - Hear Me Out
                                12. Yotto - Walls
                                13. Yotto - Waiting Here
                                """)
        let album3 = Album(name: "Last Night at Output", artist: "John Digweed", year: "2019", recordLabel: "Bedrock", photo: photo3, trackList: """
            Disc: 1
              1. The Last Dance - Eagles & Butterflies
              2. Singing - Dixon Club - Agoria Ft Scalde
              3. Tiny Little Things - Tripswitch Remix - Geist
              4. Last Tango - Daso Remix - Butch & Julie Marghilano
              5. Butch & Julie Marghilano - Pablo Sanchez
              6. I Rise - François K Journey Vocal - Emilie Nana
              7. South West - Martin Buttrich
              8. Zoulou - Alex Niggemann
              9. I Am Here - André Kronert Remix - Florian Kruse & Tesla Nix
              10. Cyclone - Mulya
              11. Romeo - Mulya

            Disc: 2
              1. The Sky Turned Pink - James Holden Remix - Nathan Fake
              2. Too Much Information - Laolu Remix - Dele Sosimi Afrobeat Orchestra
              3. Enter Galactic - Raxon
              4. Ranking - Raw District
              5. Earthlings X - Jimpster Reemix - Danny Howells
              6. South West - Martin Buttrich
              7. Lost Youth - Jonas Rathman
              8. Stickup - Randall Jones
              9. Crazy - Pig & Dan
              10. Den Raytta Feat Volcano - Ame
              11. Farmacia (a Hommage to Frankfurt) - Kenneth Bager & Phunk
              12. Scala - Agoria

            Disc: 3
              1. Crazy Diamond - John & Nick
              2. Chicago Story - Oxia Remix - Acumen
              3. Judy (Hooked on Coke) - Jole
              4. 33 Janus - Aaron
              5. Jarry - All Is Well
              6. Raving at the Acropolis - Massimiliano Pagliara Rivers of North
              7. Rapid Eye Movement - Verche
              8. Modest Is Hottest - Sobek
              9. Chord Cluster - Cassy Full on Dub Mix - Steve Bug & Langenberg
              10. Rotlicht - Raxon Remix - Oliver Huntemann
              11. Satellite - Oxia Remix - John Digweed & Nick Muir
              12. Run the City - Anja Schneider
              13. La Vida - Argy

            Disc: 4
              1. Nowadays - Andre Hommen
              2. Transfunction - Tom Demac Remix - PBR Streetgang
              3. Destiny - Raxon
              4. Selee - Super Flu
              5. Red Giant - Nicolas Masseyeff Remix - Frankyeffe
              6. Blue Mountain - Quenum
              7. Human Patterns - Roman Flügel Remix - Beanfield
              8. Now Is the Time - 2020 Soundsystem Remix - Layo & Bushwacka
              9. Ayam - Red Axes Remix - Acid Pauli & Martin Gretschmann
              10. Tatischeff - Ame
              11. Flying Through You - Per Hammer End Station Mix - Jean Pierre & Trangaz
              12. The Future - Claude Vonstroke Remix - Tom Flynn Feat. Amp Fiddler
              13. The End - Richie G Remix - Hot Since 82 Vs Joe T Vannelli Feat. Csilla
              14. Color the Rain - Stereocalypse Remix - Flowers and Sea Creatures

            Disc: 5
              1. Get Real - Just Be Rub - Paul Rutherford
              2. Eterea - Frankyeffe
              3. Super - Ivory
              4. Modol - Fairmont
              5. Inside - Dub - Better Lost Than Stupid
              6. Mars Beats - Josh Wink
              7. Aries in Mars - Josh Wink
              8. Swinging at Da Suga - Laurent Garnier
              9. Ourselves Behind Ourselves - the Drfiter Remix - Shiffer
              10. Velleity - Reset Robot
              11. Jaguar - Alberto Ruiz Remix - Pig & Dan

            Disc: 6
              1. Reset Your Bassline - Pig & Dan
              2. Pitch Black - Future Beat Alliance
              3. The Wheel - James Holden
              4. Sequential Error - Marc Romboy
              5. Adamedge - Nathan Fake
              6. Electric Djedi Disco Biscuit - Laurent Garnier
              7. Acid Madness - Madben
              8. Violet Phosphorous - Oliver Lieb
              9. Discolabirinto - Drag & Drop
              10. Acid Eiffel - Choice
            """)
        let album4 = Album(name: "My Beautiful Dark Twisted Fantasy", artist: "Kanye West", year: "2010", recordLabel: "Def Jam Roc-A-Fella", photo: photo4, trackList: """
            1. Dark Fantasy (Album Version (Explicit)) [Explicit] 04:40
            2. Gorgeous (Album Version (Explicit)) [feat. Raekwon] [Explicit] 05:57
            3. Power (Album Version (Explicit)) [Explicit] 04:52
            4. All Of The Lights (Interlude) (Album Version (Explicit)) [Explicit] 01:02
            5. All Of The Lights (Album Version (Explicit)) [Explicit] 04:59
            6. Monster (Album Version (Explicit)) [feat. Bon Iver] [Explicit] 06:18
            7. So Appalled (Album Version (Explicit)) [feat. Pusha T] [Explicit] 06:37
            8. Devil In A New Dress (Album Version (Explicit)) [feat. Rick Ross] [Explicit] 05:52
            9. Runaway (Album Version (Explicit)) [feat. Pusha T] [Explicit] 09:07
            10. Hell Of A Life (Album Version (Explicit)) [Explicit] 05:27
            11. Blame Game (Album Version (Explicit)) [feat. John Legend] [Explicit] 07:49
            12. Lost In The World (Album Version (Explicit)) [feat. Bon Iver] [Explicit] 04:16
            13. Who Will Survive In America (Album Version (Explicit)) [Explicit] 01:38
            """)
        let album5 = Album(name: "Metaphorical Music", artist: "Nujabes", year: "2003", recordLabel: "Hydeout Productions", photo: photo5, trackList: """
            1. Blessing It -Remix (feat. Substantial & Pase Rock from Five Deez)
            2. Horn in the Middle
            3. Lady Brown (Feat. Cise Starr From Cyne)
            4. Kumomi
            5. Highs 2 Lows (Feat. Cise Starr From Cyne)
            6. Beat Laments the World
            7. Letter from Yokosuka
            8. Think Different (feat. Substantial)
            9. A Day by Atmosphere Supreme
            10. Next View (feat. Uyama Hiroto)
            11. Latitude -Remix (feat. Five Deez)
            12. F.I.L.O. (feat. Shing02)
            13. Summer Gypsy
            14. The Final View
            15. Peaceland
            """)
        let album6 = Album(name: "Modal Soul", artist: "Nujabes", year: "2005", recordLabel: "Hydeout Productions", photo: photo6, trackList: """
            1.    "Feather" (featuring Cise Starr & Akin)    2:55
            2.    "Ordinary Joe" (featuring Terry Callier)    5:07
            3.    "Reflection Eternal"    4:17
            4.    "Luv (Sic.) Part 3" (featuring Shing02)    5:36
            5.    "Music Is Mine"    4:20
            6.    "Eclipse" (featuring Substantial)    3:34
            7.    "The Sign" (featuring Pase Rock)    4:49
            8.    "Thank You" (featuring Apani B)    4:09
            9.    "World's End Rhapsody"    5:41
            10.    "Modal Soul" (featuring Uyama Hiroto)    4:41
            11.    "Flowers"    3:59
            12.    "Sea of Cloud"    3:01
            13.    "Light on the Land"    3:55
            14.    "Horizon"    7:20
            """)
        let album7 = Album(name: "Music for the Jilted Generation", artist: "The Prodigy", year: "1994", recordLabel: "XL Recordings", photo: photo7, trackList: """
            1.    "Intro"
            2.    "Break & Enter"
            3.    "Their Law" (featuring Pop Will Eat Itself)
            4.    "Full Throttle"
            5.    "Voodoo People"
            6.    "Speedway (Theme From Fastlane)"
            7.    "The Heat (The Energy)"
            8.    "Poison"
            9.    "No Good (Start the Dance)"
            10.    "One Love"
            11.    "The Narcotic Suite: 3 Kilos"
            12.    "The Narcotic Suite: Skylined"
            13.    "The Narcotic Suite: Claustrophobic Sting"
            """)
        let album8 = Album(name: "DJ KICKS (Photek)", artist: "Photek", year: "2012", recordLabel: "!K7 Records", photo: photo8, trackList: """
            1. Photek - Azymuth 03:54
            2. Kromestar - In 2 Minds 05:50
            3. Hot Toddy - I Need Love feat. Ron Basejam (Morgan Geist's Love Dub) 06:29
            4. DLX - Modern Man 05:21
            5. DJG - Here Come The Dark Lights 05:43
            6. Dustmite & Kuru - Bare 04:39
            7. Photek & Pinch - M25FM 04:10
            8. Photek - No Agenda 07:29
            9. Marco Effe - Sexgas (Arnaud Le Texier Rmx) 06:32
            10. DJG - Say Something 06:12
            11. Guy J & Miriam Vaga - No Under But You 04:07
            12. Daze Maxim - Tomorrow Universe 08:02
            13. Sepalcure - Taking You Back 07:26
            14. Photek - Levitation 04:51
            15. Photek & Kuru - Fountainhead (DJ-Kicks) 04:18
            16. Synkro - Look At Yourself 04:36
            17. Photek - 101 (Boddika Remix) 05:05
            18. Parxe & Grincheux - The Art of Nothing Pt. 1 04:19
            19. Photek presents Various Artists - Photek DJ-Kicks Mix 01:05:19
            """)
        let album9 = Album(name: "Eric Prydz Presents Pryda", artist: "Pryda", year: "2012", recordLabel: "Virgin Records", photo: photo9, trackList: """
            Disc 1: Eric Prydz Presents Pryda
            No.    Title    Length
            1.    "Shadows"    6:05
            2.    "Agag"    5:51
            3.    "Beyond 8"    5:44
            4.    "Javlar"    6:24
            5.    "Sunburst"    5:33
            6.    "Hardrock Lausanne"    4:58
            7.    "You"    6:58
            8.    "SW4"    5:27
            9.    "Leja"    5:57
            10.    "Mighty Love" (instrumental)    5:41
            11.    "Allein"    5:36
            12.    "You" (interlude)    3:18
            13.    "Pjanoo" (Eric's Intro Edit)    5:59
            Total length:    73:32

            Disc 2: Retrospective Mix 01
            No.    Title    Length
            1.    "Lesson One"    4:41
            2.    "Miami to Atlanta"    4:27
            3.    "Genesis"    7:29
            4.    "Rakfunk"    3:26
            5.    "Europa"    6:02
            6.    "Aftermath" (Eric's Edit)    9:01
            7.    "Frankfurt"    5:35
            8.    "Armed"    5:51
            9.    "Reeperbahn"    5:58
            10.    "Muranyi"    5:54
            11.    "1983" (Eric Prydz Remix; Originally by Paolo Mojo)    10:40
            12.    "The Gift"    6:25
            Total length:    75:29

            Disc 3: Retrospective Mix 02
            No.    Title    Length
            1.    "The End"    7:22
            2.    "Rymd"    8:04
            3.    "Waves"    5:58
            4.    "Emos"    6:59
            5.    "Viro" (Eric's Intro Edit)    8:47
            6.    "Glimma"    4:57
            7.    "Juletider"    5:13
            8.    "With Me"    5:21
            9.    "2Night"    6:58
            10.    "Melo" (Eric's Special Edit)    6:28
            11.    "M.S.B.O.Y"    5:35
            12.    "Mirage"    6:47
            """)
        let album10 = Album(name: "Random Access Memories", artist: "Daft Punk", year: "2013", recordLabel: "Daft Life Columbia", photo: photo10, trackList: """
            1) “Give Life Back to Music”
            2) “The Game of Love”
            3) “Giorgio by Moroder”
            4) “Within”
            5) “Instant Crush”
            6) “Lose Yourself to Dance”
            7) “Touch”
            8) “Get Lucky”
            9) “Beyond”
            10) “Motherboard”
            11) “Fragments of Time”
            12) “Doin’ It Right”
            13) “Contact”
            """)
        let album11 = Album(name: "Spiritual State", artist: "Nujabes", year: "2011", recordLabel: "Hydeout Productions", photo: photo11, trackList: """
            1.    "Spiritual State" (featuring Uyama Hiroto)    Nujabes    6:32
            2.    "Sky Is Tumbling" (featuring Cise Starr)    Nujabes    4:29
            3.    "Gone Are the Days" (featuring Uyama Hiroto)    Nujabes    6:02
            4.    "Spiral"    Nujabes    3:41
            5.    "City Lights" (featuring Pase Rock and Substantial)    Nujabes    3:14
            6.    "Color of Autumn"    Nujabes    1:43
            7.    "Dawn On the Side"    Nujabes    5:15
            8.    "Yes" (featuring Pase Rock)    Nujabes    7:51
            9.    "Rainyway Back Home"    Nujabes    2:36
            10.    "Far Fowls"    Nujabes    4:24
            11.    "Fellows"    Nujabes    2:03
            12.    "Waiting For the Clouds" (featuring Substantial)    Nujabes    3:52
            13.    "Prayer"    Nujabes    3:29
            14.    "Island" (featuring Uyama Hiroto and Haruka Nakamura)    Nujabes    5:07
            """)
        let album12 = Album(name: "The Gifted", artist: "Wale", year: "2013", recordLabel: "Maybach Music", photo: photo12, trackList: """
            1. The Curse Of The Gifted
            2. LoveHate Thing ft. Sam Dew
            3. Sunshine
            4. Heaven’s Afternoon ft. Meek Mill
            5. Golden Salvation (Jesus Piece)
            6. Vanity
            7. Gullible ft. CeeLo Green
            8. Bricks ft. Yo Gotti & Lyfe Jennings
            9. Clappers ft. Nicki Minaj & Juicy J
            10. Bad (Remix) ft. Rihanna
            11. Tired of Dreaming ft. Ne-Yo & Rick Ross
            12. Rotation ft. Wiz Khalifa & 2 Chainz
            13. Simple Man
            14. 88
            15. Black Heroes / Outro About Nothing ft. Jerry Seinfeld
            16. Bad ft. Tiara Thomas
            """)
        
        albums += [album1, album2, album3, album4, album5, album6, album7, album8, album9, album10, album11, album12]
    }
    
    private func saveAlbums() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(albums, toFile: Album.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Albums successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save albums...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadAlbums() -> [Album]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Album.ArchiveURL.path) as? [Album]
    }

}
