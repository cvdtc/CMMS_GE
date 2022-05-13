import React from 'react';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

/// import react router dom
import { Link } from 'react-router-dom'

/// import data table
import { AgGridReact } from 'ag-grid-react'
import 'ag-grid-community/dist/styles/ag-grid.css';
import 'ag-grid-community/dist/styles/ag-theme-alpine.css';

/// import axios 
import axios from '../../../utils/server';
import swal from 'sweetalert';
class ListSite extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            /// modal handler show or hide
            showmodal: true,
            /// state for data site
            dataSite: [],
            /// AG Data Grid column and row definition
            columnDefs: [
                {
                    headerName: "Nama Site",
                    field: 'nama',
                },
                {
                    headerName: "Keterangan",
                    field: 'keterangan',
                },
                {
                    headerName: 'Action',
                    field: 'idsite',
                    cellRendererFramework: (params) => <div className='inline-flex rounded-md' role='group'><Link to='/editsite/' state={{ data: params.data }} type='button' className="py-2 px-3 text-sm font-medium rounded-l-lg border border-gray-300 bg-green-500 text-white">Edit</Link><button onClick={() => this.KonfirmHapusData(params)} className="py-2 px-2 text-sm font-small rounded-r-lg border border-gray-300 bg-red-500 text-white">Delete</button></div>
                }
            ],
            /// AG Data Grid default column options
            defaultColDef: {
                editable: true,
                sortable: true,
                flex: 1,
                minWidth: 100,
                filter: true,
                floatingFilter: true,
                resizable: true,
            },
            gridOptions: {
                pagination: true,
                paginationAutoPageSize: true,
                enableFilter: true,
                enableSorting: true
            }
        }
    }

    /// modal konfirmasi
    async KonfirmHapusData(params) {
        swal({
            title: `Yakin Akan Menghapus Data ${params.data.nama}?`,
            text: "Pastikan data yang anda hapus sudah sesuai!",
            icon: "warning",
            buttons: true,
            dangerMode: true,
            closeOnClickOutside: false,
            closeOnEsc: false,
        }).then((willDelete) => {
            if (willDelete) {
                this.HapusData(params.data.idsite)
            }
        });
    }

    /// init state
    async componentDidMount() {
        await this.getDataSite()
    }


    /// getting data site from api
    async getDataSite() {
        this.setState({ loading: true })
        axios.get("site", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            this.setState({ dataSite: response.data.data })
        }).catch((error) => {
            swal(`Sorry! ${error.response.message}`, {
                icon: "error",
            });
        }).finally(() => {
            this.setState({ loading: false })
        })
    }

    /// action delete
    async HapusData(idsite) {
        await axios.delete("site/" + idsite, {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            swal(`${response.data.message}`, {
                icon: "success",
            });
            this.getDataSite()
        }).catch((error) => {
            swal(`Sorry! ${error.response.message}`, {
                icon: "error",
            });
        }).finally(() => {
        })
    }

    render() {
        return (
            <>
                {/* /// navigation bar */}
                <NavbarComponent />
                <div className="md:container md:mx-auto mt-3">
                    <div className='grid grid-cols-6 gap-4 '>
                        <div className='col-start-1 col-end-3'>
                            {/* /// name page */}
                            <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                                Data Site
                            </h1>
                        </div>
                        {/* /// button tambah */}
                        <div className='col-end-7 col-span-1'>
                            <div className="flex-auto justify-center items-center mt-6">
                                <Link to='/addsite'>
                                    <button className="w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-700">Tambah Site</button>
                                </Link>

                            </div>
                        </div>
                    </div>
                    {/* /// condition to load data grid komponent */}
                    <div className='ag-theme-alpine' style={{ height: '100vh' }}>
                        <AgGridReact
                            suppressExcelExport={true}
                            rowData={this.state.dataSite}
                            columnDefs={this.state.columnDefs}
                            animateRows={true}
                            gridOptions={this.state.gridOptions}
                            defaultColDef={this.state.defaultColDef}
                            loadingCellRendererParams={this.state.loadingCellRendererParams}
                        />
                    </div>
                </div>
            </>
        );
    }
}

export default ListSite;
