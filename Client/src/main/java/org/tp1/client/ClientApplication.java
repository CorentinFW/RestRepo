package org.tp1.client;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;
import org.tp1.client.cli.ClientCLIRest;

/**
 * Application principale du client
 * Lance l'interface CLI pour communiquer avec l'agence via REST
 */
@SpringBootApplication
public class ClientApplication {

    public static void main(String[] args) {
        // Démarrer Spring Boot mais sans serveur web
        ConfigurableApplicationContext context = SpringApplication.run(ClientApplication.class, args);

        // Récupérer le CLI REST et le démarrer
        ClientCLIRest cli = context.getBean(ClientCLIRest.class);
        cli.run();

        // Fermer le contexte Spring après la fin du CLI
        System.exit(SpringApplication.exit(context));
    }
}

