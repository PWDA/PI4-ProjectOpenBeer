package br.com.wda.OpenBeerProject.Repository;

import br.com.wda.OpenBeerProject.Entity.Carrinho;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

/**
 *
 * @author Darlan Silva
 * @author Wesley Moura
 * @author Alison Souza
 *
 */
@Repository
public interface CarrinhoRepository extends JpaRepository<Carrinho, Integer>{
    
}
