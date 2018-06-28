package mksgroup.goodway.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import mksgroup.goodway.entity.Vehicle;
import mksgroup.goodway.model.VehicleModel;
import mksgroup.goodway.util.AppUtil;

@Controller
public class QuestionController {

    private final static Logger LOG = LoggerFactory.getLogger(QuestionController.class);
    
    @PostMapping("/question/save")
    @ResponseBody
    public Iterable<Question> saveQuestion(@Valid @RequestBody Question data, Errors errors, HttpServletRequest request) {
        LOG.info("saveVehicles....");
        
        // If error, just return a 400 bad request, along with the error message
        if (errors.hasErrors()) {

            LOG.error(errors.getAllErrors()
                        .stream().map(x -> x.getDefaultMessage())
                        .collect(Collectors.joining(",")));

            return null;
        } else {
            Iterable<Question> entities = AppUtil.parseQuestion(data);
            List<Question> entityList = new ArrayList<Question>();

            entities.forEach(e-> entityList.add(e));
            List<Vehicle> vehilces = (List<Vehicle>) vehicleRepository.findAll();
            for(Vehicle v : vehilces) {
                if(!entityList.contains(v)) {
                    vehicleRepository.delete(v);
                }
            }
            
            vehicleRepository.saveAll(entities);
            LOG.info("vehicleModel=" + data + ";request=" + request);
        }
        
        // Reload data from db
        Iterable<Vehicle> orders = vehicleRepository.findAll();
        
        return orders;
    }
}
