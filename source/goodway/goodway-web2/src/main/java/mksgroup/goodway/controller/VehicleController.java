/**
 * Copyright 2018, MKS GROUP.
 */
package mksgroup.goodway.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import mksgroup.goodway.entity.Vehicle;
import mksgroup.goodway.model.VehicleModel;
import mksgroup.goodway.repository.VehicleRepository;
import mksgroup.goodway.util.AppUtil;

/**
 * This controller processes requests about Vehicle.
 * @author ThachLN
 */
@Controller
public class VehicleController {
    /** For logging. */
    private final static Logger LOG = LoggerFactory.getLogger(VehicleController.class);

    @Autowired
    private VehicleRepository vehicleRepository;
    
    /**
     * Goto the index page.
     * @return
     */
    @RequestMapping({"/vehicle", "/vehicle/search"})
    public String goVehicleSearch() {
        return "vehicle/search";
    }

    @RequestMapping("/vehicle/new")
    public String goVehiclerNew() {
        return "vehicle/new";
    }
    
    
    /**
     * Load danh sách các xe.
     * @param packageId
     * @return
     */
    @GetMapping("/vehicle/load-vehicle")
    @ResponseBody
    public Iterable<Vehicle> loadVehicles() {

        Iterable<Vehicle> vehicles = vehicleRepository.findAll();
        
        return vehicles;
    }
    
    
    @PostMapping("/vehicle/save")
    @ResponseBody
    public Iterable<Vehicle> saveVehicles(@Valid @RequestBody VehicleModel data, Errors errors, HttpServletRequest request) {
        LOG.info("saveVehicles....");
        
        // If error, just return a 400 bad request, along with the error message
        if (errors.hasErrors()) {

            LOG.error(errors.getAllErrors()
                        .stream().map(x -> x.getDefaultMessage())
                        .collect(Collectors.joining(",")));

            return null;
        } else {
            Iterable<Vehicle> entities = AppUtil.parseVehicle(data);
            List<Vehicle> entityList = new ArrayList<Vehicle>();

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
