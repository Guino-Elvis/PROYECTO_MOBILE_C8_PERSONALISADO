package com.Mariategui.auth.config;

import com.Mariategui.auth.entity.AuthUser;
import com.Mariategui.auth.repository.AuthRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class UserSeeder implements CommandLineRunner {

    private final AuthRepository repository;
    private final PasswordEncoder passwordEncoder;

    public UserSeeder(AuthRepository repository, PasswordEncoder passwordEncoder) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {

        repository.deleteAll();

        String rawPassword = "admin123";
        String rawPassword2 = "jose1234";
        String encodedPassword = passwordEncoder.encode(rawPassword);
        String encodedPassword2 = passwordEncoder.encode(rawPassword2);

        AuthUser user = AuthUser.builder()
                .foto("https://example.com/foto.jpg")
                .role("admin")
                .name("ADMIN")
                .apellido_p("----")
                .apellido_m("----")
                .email("admin@gmail.com")
                .password(encodedPassword)
                .confirmPassword(encodedPassword)
                .dni("12345678")
                .codigo("U12345")
                .created_at(LocalDateTime.now())
                .updated_at(LocalDateTime.now())
                .build();

          AuthUser user2 = AuthUser.builder()
                .foto("https://example.com/foto.jpg")
                .role("user")
                .name("jose")
                .apellido_p("quispe")
                .apellido_m("arizaca")
                .email("jose@gmail.com")
                .password(encodedPassword2)
                .confirmPassword(encodedPassword2)
                .dni("12345678")
                .codigo("U123456")
                .created_at(LocalDateTime.now())
                .updated_at(LocalDateTime.now())
                .build();        

        repository.save(user);
        repository.save(user2);
        System.out.println("✅ Usuario admin creado con contraseña encriptada.");

    }
}