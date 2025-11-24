//
// Ce fichier a été généré par l'implémentation de référence JavaTM Architecture for XML Binding (JAXB), v2.3.0 
// Voir <a href="https://javaee.github.io/jaxb-v2/">https://javaee.github.io/jaxb-v2/</a> 
// Toute modification apportée à ce fichier sera perdue lors de la recompilation du schéma source. 
// Généré le : 2025.11.19 à 08:37:05 AM CET 
//


package org.tp1.client.wsdl.agence;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Classe Java pour reservation complex type.
 * 
 * <p>Le fragment de schéma suivant indique le contenu attendu figurant dans cette classe.
 * 
 * <pre>
 * &lt;complexType name="reservation"&gt;
 *   &lt;complexContent&gt;
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType"&gt;
 *       &lt;sequence&gt;
 *         &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}int"/&gt;
 *         &lt;element name="clientNom" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="clientPrenom" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="chambreId" type="{http://www.w3.org/2001/XMLSchema}int"/&gt;
 *         &lt;element name="chambreNom" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="dateArrive" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *         &lt;element name="dateDepart" type="{http://www.w3.org/2001/XMLSchema}string"/&gt;
 *       &lt;/sequence&gt;
 *     &lt;/restriction&gt;
 *   &lt;/complexContent&gt;
 * &lt;/complexType&gt;
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "reservation", propOrder = {
    "id",
    "clientNom",
    "clientPrenom",
    "chambreId",
    "chambreNom",
    "dateArrive",
    "dateDepart"
})
public class Reservation {

    protected int id;
    @XmlElement(required = true)
    protected String clientNom;
    @XmlElement(required = true)
    protected String clientPrenom;
    protected int chambreId;
    @XmlElement(required = true)
    protected String chambreNom;
    @XmlElement(required = true)
    protected String dateArrive;
    @XmlElement(required = true)
    protected String dateDepart;

    /**
     * Obtient la valeur de la propriété id.
     * 
     */
    public int getId() {
        return id;
    }

    /**
     * Définit la valeur de la propriété id.
     * 
     */
    public void setId(int value) {
        this.id = value;
    }

    /**
     * Obtient la valeur de la propriété clientNom.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getClientNom() {
        return clientNom;
    }

    /**
     * Définit la valeur de la propriété clientNom.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setClientNom(String value) {
        this.clientNom = value;
    }

    /**
     * Obtient la valeur de la propriété clientPrenom.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getClientPrenom() {
        return clientPrenom;
    }

    /**
     * Définit la valeur de la propriété clientPrenom.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setClientPrenom(String value) {
        this.clientPrenom = value;
    }

    /**
     * Obtient la valeur de la propriété chambreId.
     * 
     */
    public int getChambreId() {
        return chambreId;
    }

    /**
     * Définit la valeur de la propriété chambreId.
     * 
     */
    public void setChambreId(int value) {
        this.chambreId = value;
    }

    /**
     * Obtient la valeur de la propriété chambreNom.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getChambreNom() {
        return chambreNom;
    }

    /**
     * Définit la valeur de la propriété chambreNom.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setChambreNom(String value) {
        this.chambreNom = value;
    }

    /**
     * Obtient la valeur de la propriété dateArrive.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDateArrive() {
        return dateArrive;
    }

    /**
     * Définit la valeur de la propriété dateArrive.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDateArrive(String value) {
        this.dateArrive = value;
    }

    /**
     * Obtient la valeur de la propriété dateDepart.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDateDepart() {
        return dateDepart;
    }

    /**
     * Définit la valeur de la propriété dateDepart.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDateDepart(String value) {
        this.dateDepart = value;
    }

}
