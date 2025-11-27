package org.tp1.hotellerie.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.tp1.hotellerie.model.*;
import org.tp1.hotellerie.repository.*;

import javax.annotation.PostConstruct;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Service pour gérer l'hôtel avec persistance en base de données H2
 */
@Service
@Transactional
public class HotelService {

    @Autowired
    private HotelRepository hotelRepository;

    @Autowired
    private ChambreRepository chambreRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @Autowired
    private ClientRepository clientRepository;

    private Hotel hotel;
    private AtomicInteger reservationIdCounter = new AtomicInteger(1);

    @Value("${hotel.nom:Grand Hotel Paris}")
    private String hotelNom;

    @Value("${hotel.adresse:10 Rue de la Paix, Paris}")
    private String hotelAdresse;

    @Value("${hotel.categorie:CAT5}")
    private String hotelCategorie;

    @Value("${hotel.ville:Paris}")
    private String hotelVille;

    @Value("${server.port:8082}")
    private int serverPort;

    @PostConstruct
    public void init() {
        // Convertir la catégorie String en Type enum
        Type type = Type.valueOf(hotelCategorie);

        System.out.println("═══════════════════════════════════════════");
        System.out.println("  Initialisation Hôtel: " + hotelVille);
        System.out.println("  Nom: " + hotelNom);
        System.out.println("  Adresse: " + hotelAdresse);
        System.out.println("  Catégorie: " + type);

        // Vérifier si l'hôtel existe déjà dans la base
        Optional<Hotel> existingHotel = hotelRepository.findByNomAndAdresse(hotelNom, hotelAdresse);

        if (existingHotel.isPresent()) {
            hotel = existingHotel.get();
            System.out.println("  ✓ Hôtel chargé depuis la base de données");
            System.out.println("  Chambres en base: " + hotel.getListeDesChambres().size());
            System.out.println("  Réservations en base: " + hotel.getListeReservation().size());
        } else {
            // Créer un nouvel hôtel
            hotel = new Hotel(hotelNom, hotelAdresse, type);
            hotel = hotelRepository.save(hotel);
            System.out.println("  ✓ Nouvel hôtel créé dans la base");

            // Déterminer l'image selon la ville
            String imageFileName = getImageFileName();
            String imageUrl = "http://localhost:" + serverPort + "/images/" + imageFileName;

            // Ajouter des chambres différentes selon la ville
            if ("Paris".equals(hotelVille)) {
                ajouterChambre(1, "Chambre Simple", 80.0f, 1, imageUrl);
                ajouterChambre(2, "Chambre Double", 120.0f, 2, imageUrl);
                ajouterChambre(3, "Suite Deluxe", 200.0f, 3, imageUrl);
                ajouterChambre(4, "Chambre Familiale", 150.0f, 4, imageUrl);
                ajouterChambre(5, "Chambre Economy", 60.0f, 1, imageUrl);
            } else if ("Lyon".equals(hotelVille)) {
                ajouterChambre(11, "Chambre Standard", 70.0f, 1, imageUrl);
                ajouterChambre(12, "Chambre Confort", 100.0f, 2, imageUrl);
                ajouterChambre(13, "Suite Junior", 150.0f, 2, imageUrl);
                ajouterChambre(14, "Chambre Triple", 130.0f, 3, imageUrl);
                ajouterChambre(15, "Chambre Budget", 50.0f, 1, imageUrl);
            } else if ("Montpellier".equals(hotelVille)) {
                ajouterChambre(21, "Chambre Eco", 45.0f, 1, imageUrl);
                ajouterChambre(22, "Chambre Double Confort", 85.0f, 2, imageUrl);
                ajouterChambre(23, "Suite Vue Mer", 140.0f, 2, imageUrl);
                ajouterChambre(24, "Chambre Quad", 110.0f, 4, imageUrl);
                ajouterChambre(25, "Studio", 65.0f, 1, imageUrl);
            }

            System.out.println("  Chambres ajoutées: " + hotel.getListeDesChambres().size());
            System.out.println("  URL image: " + imageUrl);
        }

        // Initialiser le compteur de réservations
        if (!hotel.getListeReservation().isEmpty()) {
            int maxId = hotel.getListeReservation().stream()
                .mapToInt(Reservation::getNumeroReservation)
                .max()
                .orElse(0);
            reservationIdCounter.set(maxId + 1);
        }

        System.out.println("═══════════════════════════════════════════");
    }

    private void ajouterChambre(int numeroChambre, String nom, float prix, int nbrDeLit, String imageUrl) {
        // Vérifier si la chambre existe déjà
        Optional<Chambre> existing = chambreRepository.findByNumeroChambreAndHotelId(numeroChambre, hotel.getId());
        if (existing.isEmpty()) {
            Chambre chambre = new Chambre(numeroChambre, nom, prix, nbrDeLit, imageUrl);
            chambre.setHotel(hotel);
            chambreRepository.save(chambre);
            hotel.getListeDesChambres().add(chambre);
        }
    }

    private String getImageFileName() {
        switch (hotelVille) {
            case "Paris":
                return "Hotelle1.png";
            case "Lyon":
                return "Hotelle2.png";
            case "Montpellier":
                return "Hotelle3.png";
            default:
                return "Hotelle1.png";
        }
    }

    public Hotel getHotel() {
        return hotel;
    }

    /**
     * Recherche des chambres disponibles selon des critères
     */
    @Transactional(readOnly = true)
    public List<Chambre> rechercherChambres(String adresse, String dateArrive, String dateDepart,
                                            Float prixMin, Float prixMax, Integer nbrEtoile, Integer nbrLits) {

        List<Chambre> chambresDisponibles = new ArrayList<>();

        // Parsing des dates
        Date arrive = parseDate(dateArrive);
        Date depart = parseDate(dateDepart);

        if (arrive == null || depart == null || !arrive.before(depart)) {
            return chambresDisponibles;
        }

        // Vérifier si l'adresse correspond
        if (adresse != null && !adresse.trim().isEmpty()) {
            if (hotel.getAdresse() == null || !hotel.getAdresse().toLowerCase().contains(adresse.toLowerCase())) {
                return chambresDisponibles;
            }
        }

        // Vérifier le nombre d'étoiles
        if (nbrEtoile != null && nbrEtoile >= 1 && nbrEtoile <= 6) {
            if (hotel.getType() == null || hotel.getType().ordinal() + 1 != nbrEtoile) {
                return chambresDisponibles;
            }
        }

        // Récupérer toutes les chambres depuis la base
        List<Chambre> toutesLesChambres = chambreRepository.findByHotelId(hotel.getId());

        // Parcourir les chambres
        for (Chambre chambre : toutesLesChambres) {
            if (chambre == null) continue;

            // Vérifier le prix
            if (prixMin != null && prixMin > 0 && chambre.getPrix() < prixMin) continue;
            if (prixMax != null && prixMax > 0 && chambre.getPrix() > prixMax) continue;

            // Vérifier le nombre de lits
            if (nbrLits != null && nbrLits > 0 && chambre.getNbrDeLit() < nbrLits) continue;

            // Vérifier la disponibilité
            List<Reservation> reservations = reservationRepository.findOverlappingReservations(
                chambre.getId(), arrive, depart
            );

            if (reservations.isEmpty()) {
                chambresDisponibles.add(chambre);
            }
        }

        return chambresDisponibles;
    }

    /**
     * Effectue une réservation
     */
    public ReservationResult effectuerReservation(Client client, long chambreId, String dateArrive, String dateDepart) {
        // Vérifier que le client est valide
        if (client == null || client.getNom() == null || client.getNom().isEmpty()) {
            return new ReservationResult(0, false, "Client invalide");
        }

        // Trouver ou créer le client dans la base
        Client clientDB = clientRepository.findByNumeroCarteBleue(client.getNumeroCarteBleue())
            .orElse(null);

        if (clientDB == null) {
            clientDB = clientRepository.save(client);
        }

        // Trouver la chambre par son ID
        Optional<Chambre> chambreOpt = chambreRepository.findById(chambreId);

        if (chambreOpt.isEmpty()) {
            return new ReservationResult(0, false, "Chambre non trouvée");
        }

        Chambre chambre = chambreOpt.get();

        // Vérifier les dates
        Date arrive = parseDate(dateArrive);
        Date depart = parseDate(dateDepart);

        if (arrive == null || depart == null || !arrive.before(depart)) {
            return new ReservationResult(0, false, "Dates invalides");
        }

        // Vérifier la disponibilité
        List<Reservation> reservationsExistantes = reservationRepository.findOverlappingReservations(
            chambre.getId(), arrive, depart
        );

        if (!reservationsExistantes.isEmpty()) {
            return new ReservationResult(0, false, "Chambre déjà réservée pour ces dates");
        }

        // Créer la réservation
        int reservationNumero = reservationIdCounter.getAndIncrement();
        Reservation reservation = new Reservation(reservationNumero, clientDB, chambre, arrive, depart);
        reservation.setHotel(hotel);
        reservation = reservationRepository.save(reservation);

        return new ReservationResult(reservationNumero, true, "Réservation effectuée avec succès");
    }

    /**
     * Obtenir toutes les réservations
     */
    @Transactional(readOnly = true)
    public List<Reservation> getReservations() {
        return reservationRepository.findByHotelId(hotel.getId());
    }

    /**
     * Obtenir la liste des chambres qui ont au moins une réservation
     */
    @Transactional(readOnly = true)
    public List<org.tp1.hotellerie.dto.ChambreDTO> getChambresReservees() {
        List<org.tp1.hotellerie.dto.ChambreDTO> chambresReservees = new java.util.ArrayList<>();
        java.util.Set<Long> chambresReserveesIds = new java.util.HashSet<>();

        // Parcourir toutes les réservations pour identifier les chambres réservées
        List<Reservation> reservations = reservationRepository.findByHotelId(hotel.getId());
        for (Reservation reservation : reservations) {
            if (reservation != null && reservation.getChambre() != null) {
                chambresReserveesIds.add(reservation.getChambre().getId());
            }
        }

        // Créer les DTOs pour les chambres réservées
        List<Chambre> chambres = chambreRepository.findByHotelId(hotel.getId());
        for (Chambre chambre : chambres) {
            if (chambresReserveesIds.contains(chambre.getId())) {
                org.tp1.hotellerie.dto.ChambreDTO dto = new org.tp1.hotellerie.dto.ChambreDTO(
                    chambre.getId(),
                    chambre.getNom(),
                    chambre.getPrix(),
                    chambre.getNbrDeLit(),
                    hotel.getType().ordinal() + 1,
                    false,  // Non disponible car réservée
                    chambre.getImageUrl()
                );
                chambresReservees.add(dto);
            }
        }

        return chambresReservees;
    }

    // Méthodes utilitaires
    private Date parseDate(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setLenient(false);
        try {
            return sdf.parse(s);
        } catch (ParseException e) {
            return null;
        }
    }

    private String formatDate(Date date) {
        if (date == null) return null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }

    private boolean datesChevauchent(Date d1Start, Date d1End, Date d2Start, Date d2End) {
        return d1Start.before(d2End) && d2Start.before(d1End);
    }

    /**
     * Classe pour retourner le résultat d'une réservation
     */
    public static class ReservationResult {
        private final int reservationId;
        private final boolean success;
        private final String message;

        public ReservationResult(int reservationId, boolean success, String message) {
            this.reservationId = reservationId;
            this.success = success;
            this.message = message;
        }

        public int getReservationId() {
            return reservationId;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getMessage() {
            return message;
        }
    }
}


