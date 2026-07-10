package com.example.demo.jwt.dto;

/**
 * DTO trả về sau khi login thành công.
 *
 * Flutter (UserModel.fromJson) mong nhận đúng các field:
 *   id, username, email, role, active, token
 */
public class LoginResponse {

    private Long    id;
    private String  username;
    private String  email;
    private String  role;
    private Boolean active;
    private String  token;

    // Constructor đầy đủ — dùng trong LoginController
    public LoginResponse(Long id, String username, String email,
                         String role, Boolean active, String token) {
        this.id       = id;
        this.username = username;
        this.email    = email;
        this.role     = role;
        this.active   = active;
        this.token    = token;
    }

    // Getters — Jackson dùng để serialize thành JSON
    public Long    getId()       { return id; }
    public String  getUsername() { return username; }
    public String  getEmail()    { return email != null ? email : ""; }
    public String  getRole()     { return role; }
    public Boolean getActive()   { return active; }
    public String  getToken()    { return token; }
}
