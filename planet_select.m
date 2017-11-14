function planet_data = planet_select(planet)
    %% provides astronomical data for the solar system
    %
    % Jeremy Penn
    % 13/11/17
    %
    % function planet_data = planet_select(planet)
    %
    % Puropose: This function provides the astronomical data of the solar
    %           system output in vector form.
    %
    % Output:   o planet_data   - vector of astro data in the form:
    %      [Radius (km), Mass(kg), Sidereal Rot Period (d), Inc of Eq to Orbit plane (deg),... 
    %         semimajor axis of orbit (km), eccentricity, Inc of orbit to ecliptic (deg), ...
    %            Orbit sidereal period (d), Standard Gravitationa Parameter (km^3/s^2)]
    
    planet = lower(planet);
    
    switch planet
        case 'sun'
            planet_data = [696000, 1.989e30, 25.38, 7.25, NaN, NaN, NaN, NaN, 132.7e11];
        case 'mercury'
            planet_data = [2440, 330.2e21, 58.65, .01, 57.91e6, .2056, 7, 87.97, 22030];
        case 'venus'
            planet_data = [6052, 4.869e24, 243, 177.4, 108.2e6, .0067, 3.39, 224.7, 324900];
        case 'earth'
            planet_data = [6378, 5.974e24, 23.9345, 23.45, 149.6e6, .0167, 0, 365.256, 398600];
        case 'moon'
            planet_data = [1737, 73.48e21, 27.32, 6.68, 384.4e3, .0549, 5.145, 27.322, 4903];
        case 'mars'
            planet_data = [3396, 641.9e21, 24.62, 25.19, 227.9e6, .0935, 1.85, 1.881*365.256, 42828];
        case 'jupiter'
            planet_data = [71490, 1.899e27, 9.925, 3.13, 778.6e6, .0489, 1.304, 11.86*365.256, 126686000];
        case 'saturn'
            planet_data = [60270, 568.5e24, 10.66, 26.73, 1.433e9, .0565, 2.485, 29.46*365.256, 37931000];
        case 'uranus'
            planet_data = [25560, 86.83e24, 17.24, 97.77, 2.872e9, .0457, .772, 84.01*365.256, 5794000];
        case 'neptune'
            planet_data = [24760, 102.4e24, 16.11, 28.32, 4.495e9, .0113, 1.769, 164.8*365.256, 6835100];
        case 'pluto'
            planet_data = [1195, 12.5e21, 6.387, 122.5, 5.870e9, .2444, 17.16, 247.7*365.256, 830];
        otherwise
            error('Error: selected planet not available. Please try again.')
    end
end