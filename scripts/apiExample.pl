# An example script demonstrating the use of BioMart API.

use strict;
use BioMart::Initializer;
use BioMart::Query;
use BioMart::QueryRunner;


my $confFile = "apiExampleRegistry.xml";
die ("Cant find configuration file $confFile\n") unless (-f $confFile);

my $initializer = BioMart::Initializer->new('registryFile'=>$confFile, 'action'=>'clean');
my $registry = $initializer->getRegistry;


# you can check for the available filters and attributes here
# you need to uncomment a print statement in the sub
&check_available_datasets_filters_attributes($registry);

# or just run your favourite query
&setup_and_run_query($registry);



sub setup_and_run_query {
    
    my $registry = shift;
    
    my $query = BioMart::Query->new('registry'=>$registry,'virtualSchemaName'=>'default');
     
    $query->setDataset("uniprot");
    $query->addAttribute("sptr_ac");
    $query->addFilter("has_pdb_info", ["excluded"]);
    
    $query->setDataset('msd');
    $query->addAttribute("pdb_id");
    $query->addAttribute("experiment_type");

    
    # $query->formatter('HTML'); leave this blank for tab delimited

    my $query_runner = BioMart::QueryRunner->new();
    $query_runner->execute($query);
    $query_runner->printHeader();
    $query_runner->printResults();
    $query_runner->printFooter();
    
}



sub check_available_datasets_filters_attributes {

    my $registry =shift;
    
    foreach my $schema (@{$registry->getAllVirtualSchemas()}){
	foreach my $mart (@{$schema->getAllMarts()}){
	    foreach my $dataset (@{$mart->getAllDatasets()}){
		foreach my $configurationTree (@{$dataset->getAllConfigurationTrees()}){                                       
		    foreach my $attributeTree (@{$configurationTree->getAllAttributeTrees()}){
			foreach my $group(@{$attributeTree->getAllAttributeGroups()}){
			    foreach my $collection (@{$group->getAllCollections()}){
				foreach my $attribute (@{$collection->getAllAttributes()}){
# 				    print "mart: ",$mart->name, 
# 				    "\tdataset: ",$dataset->name,
# 				    "\tattribute: ",$attribute->name,"\n";
				}
			    }
			}					       
		    }
		}    
	    }
	}
    }
    
}
