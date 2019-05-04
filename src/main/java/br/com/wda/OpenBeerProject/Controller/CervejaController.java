/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.wda.OpenBeerProject.Controller;

import br.com.wda.OpenBeerProject.Entity.Cerveja;
import br.com.wda.OpenBeerProject.Entity.TipoCerveja;
import br.com.wda.OpenBeerProject.Repository.CervejaRepository;
import br.com.wda.OpenBeerProject.Repository.TipoCervejaRepository;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 *
 * @author Darlan Silva
 * @author Wesley Moura
 * @author Alison Souza
 *
 */
@Controller
@RequestMapping("/cerveja")
public class CervejaController {

    @Autowired
    private CervejaRepository cervejaRepository;

    @Autowired
    private TipoCervejaRepository tipoCervejaRepository;

//    @GetMapping
//    public ModelAndView listar(
//            @RequestParam(name = "offset", defaultValue = "0") int offset,
//            @RequestParam(name = "qtd", defaultValue = "100") int qtd,
//            @RequestParam(name = "idsCat", required = false) List<Integer> idsCat) {
////        List<Produto> resultados;
////        if (idsCat != null && !idsCat.isEmpty()) {
////            // Busca pelos IDs das categorias informadas
////            resultados = produtoRepository.findByCategoria(idsCat);
////        } else {
////            // Lista todos os produtos usando paginacao
////            resultados = produtoRepository.findAll(offset, qtd);
////        }
////        return new ModelAndView("produto/lista").addObject("produtos", resultados);
//        List<Produto> resultados = cervejaRepository.findByPrecoVendaGreaterThanAndPrecoVendaLessThan(new BigDecimal(100),new BigDecimal(400));
//        return new ModelAndView("produto/lista").addObject("produtos", resultados);
//    }
    @GetMapping("/novo")
    public ModelAndView adicionarNovo() {
        return new ModelAndView("cadastro-produto")
                .addObject("cerveja", new Cerveja());
    }

    @GetMapping("/{id}/editar")
    public ModelAndView editar(@PathVariable("id") Long id) {
        Optional<Cerveja> optProd = cervejaRepository.findById(id);
        Cerveja cerveja = optProd.get();

        if (cerveja.getTipoCerveja() != null && !cerveja.getTipoCerveja().isEmpty()) {
            Set<Integer> idTipoCerveja = new HashSet<>();
            for (TipoCerveja tipo : cerveja.getTipoCerveja()) {
                idTipoCerveja.add(tipo.getId());
            }
            cerveja.setIdTiposCervejas(idTipoCerveja);
        }
        return new ModelAndView("cadastro-produto")
                .addObject("cerveja", cerveja);
    }

    @GetMapping("/{nome}")
    public ModelAndView editar2(@PathVariable("cerveja") String cerv) {
        Optional<Cerveja> optCerveja = cervejaRepository.findByCerveja(cerv);
        Cerveja cerveja = optCerveja.get();

        if (cerveja.getTipoCerveja() != null && !cerveja.getTipoCerveja().isEmpty()) {
            Set<Integer> idTipoCerveja = new HashSet<>();
            for (TipoCerveja tipo : cerveja.getTipoCerveja()) {
                idTipoCerveja.add(tipo.getId());
            }
            cerveja.setIdTiposCervejas(idTipoCerveja);
        }
        return new ModelAndView("cadastro-produto")
                .addObject("cerveja", cerveja);
    }

    @PostMapping("/salvar")
    public ModelAndView salvar(@ModelAttribute("cerveja") Cerveja cerveja, RedirectAttributes redirectAttributes) {
        
        cerveja.setDhInclusao(LocalDateTime.now());
        cerveja.setInativo(0);
        
        if (cerveja.getIdTiposCervejas()!= null && !cerveja.getIdTiposCervejas().isEmpty()) {
            Set<TipoCerveja> tipoCervejasSelecionadas = new HashSet<>();
            
            for (Integer idTipo : cerveja.getIdTiposCervejas()) {
                Optional<TipoCerveja> optTipoCerveja = tipoCervejaRepository.findById(idTipo);
                TipoCerveja tipo = optTipoCerveja.get();
                tipoCervejasSelecionadas.add(tipo);
                tipo.setCervejas(new HashSet<>(Arrays.asList(cerveja)));
            }
            
            cerveja.setTipoCerveja(tipoCervejasSelecionadas);
        }
        //VERIFICA SE É UMA ALTERAÇÃO PARA SALVA A DATA HORA DA ALTERAÇÃO
        if (cerveja.getId() != null){
            cerveja.setDhAlteracao(LocalDateTime.now());
        }
        
        cervejaRepository.save(cerveja);
        redirectAttributes.addFlashAttribute("mensagemSucesso",
                "Produto " + cerveja.getCerveja()+ " salvo com sucesso");
        // Falta
        return new ModelAndView("redirect:/consulta-produto");
    }

    @PostMapping("/{id}/remover")
    public ModelAndView remover(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        cervejaRepository.deleteById(id);
        
        redirectAttributes.addFlashAttribute("mensagemSucesso",
                "Cerveja ID " + id + " removido com sucesso");
        return new ModelAndView("redirect:/consulta-produto");
    }

    @ModelAttribute("tipoCerveja")
    public List<TipoCerveja> getTipoCerveja() {
        
        return tipoCervejaRepository.findAll();
    }

}
